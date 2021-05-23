//
//  SignInViewModel.swift
//  Arum
//
//  Created by trinhhc on 5/18/21.
//

import RxSwift

class SignInViewModel: BaseViewModel {
    var socialAuthUtil = SocialAuthUtil()
    
    struct Input {
        var loginSocial: Observable<SocialAuthType>
    }
    
    struct Output {
        var activityIndicator: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        input.loginSocial
            .flatMap { [weak self](type) -> Observable<Any> in
                guard let self = self else {
                    return Observable<Any>.empty()
                }
                return self.socialAuthUtil.requestAuth(type: type)
                    .trackError(self._errorTracker)
                    .trackActivity(self._activityIndicator)
            }
            
            .subscribe { (event) in
                print(event )
                //Process event here
            }
            .disposed(by: disposeBag)
        return Output(activityIndicator: activityIndicator)
    }
}
