//
//  UICollectionReusableView+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 2/28/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

// MARK: - UICollectionReusableView (Header & Footer)
enum XibCollectionSupplementaryKind {
    case header, footer
    
    var kind: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

protocol XibCollectionSupplementary {
    static var name: String { get }
    static func registerTo(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind)
    static func reusableFor(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind, at indexPath: IndexPath) -> Self?
}

extension XibCollectionSupplementary where Self: UICollectionReusableView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func registerTo(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind) {
        collectionView.registerNibSupplementaryViewFor(type: Self.self, ofKind: kind)
    }
    
    static func reusableFor(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind, at indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: name, for: indexPath) as? Self
    }
}

extension UICollectionReusableView: XibCollectionSupplementary { }
