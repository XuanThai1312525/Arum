//
//  UICollectionViewCell+Extension.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/9/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

// MARK: - UICollectionView
protocol XibCollectionViewCell {
    static var name: String { get }
    static func registerTo(collectionView: UICollectionView)
    static func reusableFor(collectionView: UICollectionView, at indexPath: IndexPath) -> Self?
}

extension XibCollectionViewCell where Self: UICollectionViewCell {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func registerTo(collectionView: UICollectionView) {
        collectionView.registerNibCellFor(type: Self.self)
    }
    
    static func reusableFor(collectionView: UICollectionView, at indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? Self
    }
}

extension UICollectionViewCell: XibCollectionViewCell {
    func setSelectedBackgroundColor(_ color: UIColor) {
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = color
        selectedBackgroundView = bgView
    }
}
