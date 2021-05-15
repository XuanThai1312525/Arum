//
//  UITextField+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func set(leftPadding value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func set(rightPadding value: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setPlaceholder(font: UIFont? = nil, textColor: UIColor? = nil) {
        guard (self.placeholder ?? "") != "" && (font != nil || textColor != nil) else { return }
        let placeholderText = self.placeholder ?? ""
        let attr = NSMutableAttributedString(string: placeholderText)
        if let font = font {
            attr.addAttributes([
                NSAttributedString.Key.font: font
            ], range: NSRange(location: 0, length: placeholderText.count))
        }
        if let textColor = textColor {
            attr.addAttributes([
                NSAttributedString.Key.foregroundColor: textColor
            ], range: NSRange(location: 0, length: placeholderText.count))
        }
        attributedPlaceholder = attr
    }
}
