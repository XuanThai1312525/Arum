//
//  ErrorTracker.swift
//  nurse-call
//
//  Created by TRINH.HO2 on 08/04/2021.
//  Copyright © 2021 tung. All rights reserved.
//

import RxSwift
import RxCocoa

final class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self).asDriverOnErrorJustComplete().asObservable()
    }
}
