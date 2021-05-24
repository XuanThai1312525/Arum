//
//  SignInViewModel.swift
//  Arum
//
//  Created by trinhhc on 5/18/21.
//

import RxSwift

class SignInViewModel: BaseViewModel {
    struct Input {
    }
    
    struct Output {
        var activityIndicator: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        return Output(activityIndicator: activityIndicator)
    }
}
