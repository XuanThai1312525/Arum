//
//  ViewModelType.swift
//  Arum
//
//  Created by trinhhc on 5/18/21.
//

import RxSwift

protocol ViewModelType {    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output

}
