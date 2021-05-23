//
//  BaseViewModel.swift
//  Arum
//
//  Created by trinhhc on 5/20/21.
//

import RxSwift
import RxCocoa

class BaseViewModel: ViewModelType {
    let disposeBag = DisposeBag()
    
    internal lazy var _errorTracker = ErrorTracker()
    lazy var errorTracker: Observable<Error>  = {
        return _errorTracker.asObservable()
    }()
    
    internal lazy var _activityIndicator = ActivityIndicator()
    lazy var activityIndicator: Observable<Bool>  = {
        return _activityIndicator.asObservable()
    }()
    
    struct Input {}
    
    struct Output{}
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
