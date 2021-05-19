//
//  SocialAuth.swift
//  Arum
//
//  Created by trinhhc on 5/19/21.
//

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import AuthenticationServices
import RxSwift

import FBSDKLoginKit
enum SocialAuthType {
    case apple,kakao,fb,naver
}
class SocialAuthUtil {
    fileprivate var socialAuth: SocialAuth!
    
    func requestAuth(type:SocialAuthType) -> Observable<Any> {
        switch type {
        case .apple:
            if #available(iOS 13, *) {
                socialAuth = AppleAuth()
            } else {
                // Fallback on earlier versions
                return Observable.empty()
            }
        case .kakao:
            socialAuth = KakaoAuth()
        case .fb:
            socialAuth = FBAuth()
        case .naver:
            socialAuth = NaverThirdPartyLoginConnectionAuth()
        }
        
        return socialAuth.requestAuth()
    }
}


class SocialAuth: NSObject {
    fileprivate var resultPublish: PublishSubject<Any> = PublishSubject()
    
    func requestAuth() ->  Observable<Any>{
        return resultPublish.asObservable()
    }
}

//MARK: Facebook
class FBAuth: SocialAuth {
    override func requestAuth() -> Observable<Any> {
        let loginManager = LoginManager()
        
        if let accessToken =  AccessToken.current, !accessToken.isExpired{
            // Access token available -- user already logged in
            // Perform log out
            print(accessToken)
            
            //force log out
            loginManager.logOut();
        }
        
        loginManager.logIn(permissions: [Permission.publicProfile.name,Permission.email.name], from: AppDelegate.shared.window!.rootViewController) { [weak self] (result, error) in
            // Check for error
            if let error = error {
                self?.resultPublish.onError(error)
                return
            }
            
            // Check for cancel
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                //Do nothing because user cannceled
                return
            }
            
            // Successfully logged in
            guard let token = result.token?.tokenString
                else {
                
                //Custom error on future
                return
            }
            
            if result.declinedPermissions.contains(Permission.publicProfile.name) || result.declinedPermissions.contains(Permission.email.name) {
                print("Need to handle later")
            }
            
            FBSDKLoginKit.Profile.loadCurrentProfile { (profile, error) in
                guard let profile = profile else {
                    self?.resultPublish.onError(error!)
                    return
                }
                
                self?.resultPublish.onNext(FacebookAuthResult(accessToken: token, email: profile.email.emptyOnNil, firstName:  profile.firstName.emptyOnNil, lastName: profile.lastName.emptyOnNil))
                self?.resultPublish.onCompleted()
            }
            
        }
        
        return super.requestAuth()
    }
}

//MARK: Apple
@available(iOS 13, *)
class AppleAuth: SocialAuth, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    override func requestAuth() -> Observable<Any> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        return super.requestAuth()
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return  AppDelegate.shared.window!
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let userFirstName: String = (appleIDCredential.fullName?.givenName).emptyOnNil
            let userLastName = (appleIDCredential.fullName?.familyName).emptyOnNil
            let userEmail = appleIDCredential.email.emptyOnNil
            let identityTokenData = appleIDCredential.identityToken
            let authorizationCodeData = appleIDCredential.authorizationCode
            var identityToken = ""
            var authorizationCode = ""
            
            if let identityTokenData = identityTokenData, let authorizationCodeData = authorizationCodeData {
                identityToken = String(data: identityTokenData, encoding: .utf8 ).emptyOnNil
                authorizationCode = String(data: authorizationCodeData, encoding: .utf8 ).emptyOnNil
            }
            
            self.resultPublish.onNext(AppleAuthResult(userIdentifier: userIdentifier , email: userEmail, firstName: userFirstName, lastName: userLastName, identityToken: identityToken, authorizationCode: authorizationCode))
            self.resultPublish.onCompleted()
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.resultPublish.onError(error)
    }
    
}

//MARK: Kakao
class KakaoAuth: SocialAuth {
    override func requestAuth() -> Observable<Any> {
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            //(prompts: [.Login])
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let oauthToken = oauthToken {
                    print("loginWithKakaoTalk() success.")
                    
                    UserApi.shared.me() {(user, error) in
                        if let user = user  {
                            print("me() success.")
                            self.resultPublish.onNext(KakaoAuthResult(accessToken: oauthToken.accessToken, refreshToken: oauthToken.refreshToken, email: (user.kakaoAccount?.email).emptyOnNil, phoneNumber: (user.kakaoAccount?.phoneNumber).emptyOnNil))
                            self.resultPublish.onCompleted()
                        }
                        
                        self.resultPublish.onError(error!)
                    }
                } else {
                    self.resultPublish.onError(error!)
                }
            }
        }
        
        return super.requestAuth()
    }
}

//MARK: Naver
class NaverThirdPartyLoginConnectionAuth: SocialAuth, NaverThirdPartyLoginConnectionDelegate {
    lazy var naverShareInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func requestAuth() -> Observable<Any> {
        naverShareInstance?.delegate = self
        naverShareInstance?.requestThirdPartyLogin()
        return super.requestAuth()
    }
    
    internal func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        completed()
    }
    
    internal func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        completed()
    }
    
    internal func oauth20ConnectionDidFinishDeleteToken() {
        completed()
    }
    
    internal func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        self.resultPublish.onError(error)
    }
    
    func completed() {
        guard let naverShareInstance = naverShareInstance else {
            return
        }
        self.resultPublish.onNext(NaverAuthResult(accessToken: naverShareInstance.accessToken, refreshToken: naverShareInstance.refreshToken))
        self.resultPublish.onCompleted()
    }
}



//MARL: Result

struct AppleAuthResult {
    var userIdentifier: String
    var email: String
    var firstName: String
    var lastName: String
    var identityToken: String
    var authorizationCode: String
}

struct FacebookAuthResult {
    var accessToken: String
    var email: String
    var firstName: String
    var lastName: String
}

struct NaverAuthResult {
    var accessToken: String
    var refreshToken: String
}

struct KakaoAuthResult {
    var accessToken: String
    var refreshToken: String
    var email: String
    var phoneNumber: String
}
