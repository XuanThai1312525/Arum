//
//  UIButton+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

// MARK: - Extension for IBInspectable
extension UIButton {
    @IBInspectable var exclusiveTap: Bool {
        get {
            return self.isExclusiveTouch
        }
        set(value) {
            self.isExclusiveTouch = value
        }
    }
}

extension UIButton {
    
}

// MARK: - General extension
extension UIButton {
    func alignTextBelowImage(spacing: CGFloat = 15.0, fixedTitleBottom: CGFloat? = nil, verticalAlign: CGFloat = 0.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            let labelString = NSString(string: self.titleLabel?.text ?? "")
            let titleSize = labelString.size(withAttributes: [.font: self.titleLabel!.font])
            let titleBottom = fixedTitleBottom ?? (self.frame.height - (imageSize.height + titleSize.height + spacing)) / 2
            let titleInsetBottom = -((self.frame.height / 2) - titleBottom + titleSize.height)
            let imageInsetBottom = spacing
            self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleInsetBottom, right: verticalAlign)
            self.imageEdgeInsets = UIEdgeInsets(top: -spacing, left: 0.0, bottom: imageInsetBottom, right: -titleSize.width)
        }
    }
    
    func alignImageToRightOfText(fixedRightBoundSpace: CGFloat? = nil, fixedRightOfTextSpace: CGFloat? = nil, verticalAlign: CGFloat = 0.0) {
        guard let imageView = imageView else { return }
        if let fixedRightBoundSpace = fixedRightBoundSpace {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: (bounds.width - fixedRightBoundSpace - imageView.frame.width), bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageView.frame.width + verticalAlign)
        } else if let fixedRightOfTextSpace = fixedRightOfTextSpace {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: verticalAlign)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: ((titleLabel?.frame.maxX ?? 0) + fixedRightOfTextSpace), bottom: 0, right: 0)
        }
    }
}
