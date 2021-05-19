//
//  BaseViewModel.swift
//  Arum
//
//  Created by trinhhc on 5/20/21.
//

import RxSwift

class BaseViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    let errorTracker = ErrorTracker()
    let activityIndicator = ActivityIndicator()
    
    struct Input {}
    
    struct Output{}
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
