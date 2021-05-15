//
//  UILabel+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

extension UILabel {
    // MARK: - Variables
    var lineNumber: Int {
        var lineCount = 0
        let textSize = CGSize(width: frame.size.width, height: .greatestFiniteMagnitude)
        let rHeight = lroundf(Float(sizeThatFits(textSize).height))
        let charSize = lroundf(Float(font.lineHeight))
        lineCount = rHeight / charSize
        return lineCount
    }
    
    // MARK: - Functions
    func sizeFit(width: CGFloat) -> CGSize {
        self.numberOfLines = Int.max
        let fixedWidth = width
        let newSize = sizeThatFits(CGSize(width: fixedWidth,
                                          height: .greatestFiniteMagnitude))
        return CGSize(width: fixedWidth, height: newSize.height)
    }
    
    func sizeFit(height: CGFloat) -> CGSize {
        self.numberOfLines = Int.max
        let fixedHeight = height
        let newSize = sizeThatFits(CGSize(width: .greatestFiniteMagnitude,
                                          height: fixedHeight))
        return CGSize(width: newSize.width, height: fixedHeight)
    }
    
    func underline() {
        if let text = self.text {
            let textRange = NSRange(location: 0, length: text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: textRange)
            self.attributedText = attributedText
        }
    }
    
    func underlineFor(subString: String) {
        guard let text = self.text, let subRange = text.nsrangeOf(subString: subString) else { return }
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: subRange)
        self.attributedText = attributedText
    }
    
    func set(lineSpacing value: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = value
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}
