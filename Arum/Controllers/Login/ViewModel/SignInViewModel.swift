//
//  SignInViewModel.swift
//  Arum
//
//  Created by trinhhc on 5/18/21.
//

import RxSwift
struct ValidateResult {
    var isValid: Bool
    var errorMessage: String
}
class SignInViewModel: BaseViewModel {
    struct Input {
        var loginWithSNSTrigger: Observable<SNSType>
        var loginNormalTrigger: Observable<Void>
        var signUpTrigger: Observable<Void>
        var nameTrigger: Observable<String>
        var phoneTrigger: Observable<String>
        var isAutoLogin: Observable<Bool>
    }
    
    struct Output {
        var activityIndicator: Observable<Bool>
        var logInSNS: Observable<String>
        var onError: Observable<Error>
        var nameValidateResult: Observable<ValidateResult>
        var phoneValidateResult: Observable<ValidateResult>
        var isAutoLoginValidResult: Observable<Bool>
        var onSignUp: Observable<String>
        var onNeedAuthentication: Observable<Bool>
    }
    func transform(input: Input) -> Output {
        let logInSNS = input.loginWithSNSTrigger.map { (type) -> String in
            switch type {
            case .fb:
                return Constants.SNS_URL.FB
            case .kakao:
                return Constants.SNS_URL.KAKAO
            case .apple:
                return Constants.SNS_URL.APPLE
            case .naver:
                return Constants.SNS_URL.NAVER
                
            }
        }
        
        let nameValidateResult =  BehaviorSubject<ValidateResult>(value: ValidateResult(isValid: false, errorMessage: "잘못된 이름"))
        let phoneValidateResult =  BehaviorSubject<ValidateResult>(value: ValidateResult(isValid: false, errorMessage: "유효하지 않은 전화 번호"))
        let isAutoLoginTrigger = BehaviorSubject<Bool>(value: false)
        
        input.nameTrigger
            .distinctUntilChanged()
            .map{ValidateResult(isValid: !$0.isEmpty, errorMessage: "잘못된 이름")}
            .bind(to: nameValidateResult)
            .disposed(by: disposeBag)
        
        input.phoneTrigger
            .distinctUntilChanged()
            .map{ValidateResult(isValid: $0.isPhoneNumber, errorMessage: "유효하지 않은 전화 번호")}
            .bind(to: phoneValidateResult)
            .disposed(by: disposeBag)
        
        
        input.isAutoLogin.map{!$0}.bind(to: isAutoLoginTrigger)
            .disposed(by: disposeBag)
        
        
        let isValid = Observable.combineLatest(nameValidateResult, phoneValidateResult).map{$0.isValid && $1.isValid}
        
        var lastedLoginRequest: LoginRequest?
        
        let loginInfo = Observable.combineLatest(input.nameTrigger,input.phoneTrigger,isAutoLoginTrigger).map { info -> LoginRequest in
            var uuid = UserSession.UUID_TOKEN ?? ""
            if let id = UserSession.userInfo?.deviceId , !id.isEmpty{
                uuid = id
            }
            
            lastedLoginRequest = LoginRequest(mobile:info.1, name: info.0, is_auto_login: info.2, device_id: uuid)
            return lastedLoginRequest!
        }
        
        let loginTrigger = input.loginNormalTrigger.withLatestFrom(isValid)
        
        
        
        loginTrigger.filter{!$0}
            .subscribe { (valid) in
                nameValidateResult.onNext(try! nameValidateResult.value())
                phoneValidateResult.onNext(try! phoneValidateResult.value())
            }.disposed(by: disposeBag)
        
        
        let loginResult = loginTrigger.filter{$0}.mapToVoid().withLatestFrom(loginInfo)
            .flatMapLatest {(info) in
                
                return APIService.login(request: info)
                    .trackActivity(self._activityIndicator)
                    .trackError(self._errorTracker)
            }
            .do(onNext: { [weak self](loginResponse) in
                guard let self = self else {
                    return
                }
                if !loginResponse.success {
                    self._errorTracker.onError(NSError.getError(message: loginResponse.msg))
                } else {
                    if let lastedLoginRequest = lastedLoginRequest {
                        let info = UserInfo.init(phoneNumber: lastedLoginRequest.mobile, name: lastedLoginRequest.name, deviceId: lastedLoginRequest.device_id, isAutomaticLogin: lastedLoginRequest.is_auto_login)
                        UserSession.saveUserInfo(info)
                        UserSession.setSessionCookie()
                    }
                    
                    switch UserSession.roleSubject.value {
                    case .needLoginOnly, .logged:
                        UserSession.roleSubject.accept(.logged)
                    default:
                        break
                    }
                }
            })
            .filter{$0.success}
            .map{_ in true}
            .share()
        
        let onNeedAuthentication = loginResult.filter{_ in UserSession.roleSubject.value == RoleAccess.needLoginAndAuthen}
        
        let onSignUp = input.signUpTrigger.map{Constants.SIGN_UP_URL}.asObservable()
        
        return Output(activityIndicator: activityIndicator, logInSNS: logInSNS,  onError: errorTracker,nameValidateResult:nameValidateResult.skip(1),phoneValidateResult: phoneValidateResult.skip(1),isAutoLoginValidResult: isAutoLoginTrigger.skip(1).asObservable(),onSignUp: onSignUp, onNeedAuthentication: onNeedAuthentication)
    }
}


typealias LoginInfo = (String, String,String)
