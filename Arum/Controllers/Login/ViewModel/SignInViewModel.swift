//
//  SignInViewModel.swift
//  Arum
//
//  Created by trinhhc on 5/18/21.
//

import RxSwift

class SignInViewModel: BaseViewModel {
    struct Input {
        var loginWithSNSTrigger: Observable<SNSType>
        var loginNormalTrigger: Observable<LoginRequest>
    }
    
    struct Output {
        var activityIndicator: Observable<Bool>
        var logInSNS: Observable<String>
        var loginSuccess: Observable<Bool>
        var onError: Observable<Error>
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
        
        let loginSuccess = input.loginNormalTrigger
            .filter({ (info) in
                return !info.name.isEmpty && info.mobile.isPhoneNumber
            })
            .flatMapLatest {(info) in
                return NetworkRequestManager.login(request: info)
                .trackActivity(self._activityIndicator)
                .trackError(self._errorTracker)
            }
            .do(onNext: { [weak self](loginResponse) in
                guard let self = self else {
                    return
                }
                if !loginResponse.success {
                    self._errorTracker.onError(NSError.getError(message: loginResponse.msg))
                }
            })
            .filter{$0.success}
            .map{_ in true}
        
        return Output(activityIndicator: activityIndicator, logInSNS: logInSNS, loginSuccess: loginSuccess, onError: errorTracker)
    }
}
