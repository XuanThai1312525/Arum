//
//  BaseCollectionView.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/9/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

class BaseCollectionView: UICollectionView {
    
    // MARK: - Closure
    var didChangeContentSize: ((_ size: CGSize) -> Void)?
    
    // MARK: - Override functions
    override var contentSize: CGSize {
        didSet {
            didChangeContentSize?(contentSize)
        }
    }
}
