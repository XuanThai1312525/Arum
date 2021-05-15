//
//  UITextView+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

extension UITextView {
    func sizeFit(width: CGFloat) -> CGSize {
        let fixedWidth = width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        return CGSize(width: fixedWidth, height: newSize.height)
    }
    
    func sizeFit(height: CGFloat) -> CGSize {
        let fixedHeight = height
        let newSize = sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: fixedHeight))
        return CGSize(width: newSize.width, height: fixedHeight)
    }
    
    func underline() {
        guard let text = self.text else { return }
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
        self.attributedText = attributedText
    }
}
