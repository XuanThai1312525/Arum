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
        
    }
    
    func transform(input: Input) -> Output {
        input.loginSocial
            .flatMap { [weak self](type) -> Observable<Any> in
                guard let self = self else {
                    return Observable<Any>.empty()
                }
                return self.socialAuthUtil.requestAuth(type: type)
            }
            .trackError(errorTracker)
            .trackActivity(activityIndicator)
            .subscribe(onNext: { (result) in
                print(result)
            }).disposed(by: disposeBag)

        
        
        return Output()
    }
}
