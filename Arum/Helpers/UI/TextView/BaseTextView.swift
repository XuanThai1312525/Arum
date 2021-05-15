//
//  BaseTextView.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

class BaseTextView: UITextView {
    
    // MARK: - Outlets
    fileprivate weak var textHintLabel: UILabel?
    
    // MARK: - Typealias
    typealias TextDidChangeResponse = ((_ newText: String) -> Void)
    typealias TextStateResponse = (() -> Void)
    
    // MARK: - Variables
    fileprivate var maxCharCount: Int?
    fileprivate var maxBytes: Int?
    
    // MARK: - Closures
    fileprivate var textDidChangeHandler: TextDidChangeResponse?
    fileprivate var didBeginEditingHandler: TextStateResponse?
    fileprivate var didEndEditingHandler: TextStateResponse?
    
    // MARK: - Draw functions
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addTextHintLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let label = textHintLabel {
            guard let _ = constraints.filter({ $0.firstAttribute == .width && ($0.firstItem as? UILabel) == label }).first else {
                let constraint = label.getFixedConstraintWith(attribute: .width, value: bounds.width - 6)
                addConstraint(constraint)
                return
            }
        }
    }
    
    // MARK: - Setup functions
    private func setupTextView() {
        delegate = self
        clipsToBounds = true
    }
    
    private func addTextHintLabel() {
        let label = UILabel()
        label.font = UIFont.normal(size: 13)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = false
        addSubview(label)
        let constraints: [NSLayoutConstraint] = [
            label.getEqualConstraintTo(superView: self, attribute: .top, constant: 16),
            label.getEqualConstraintTo(superView: self, attribute: .left, constant: 16)
        ]
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(constraints)
        
        textHintLabel = label
    }
    
    // MARK: - Builder
    @discardableResult
    func set(placeHolder: String) -> BaseTextView {
        textHintLabel?.text = placeHolder
        layoutIfNeeded()
        setNeedsDisplay()
        return self
    }
    
    @discardableResult
    func set(text: String) -> BaseTextView {
        self.text = text
        textViewDidChange(self)
        return self
    }
    
    @discardableResult
    func maxCharacters(count: Int) -> BaseTextView {
        maxCharCount = count
        return self
    }
    
    @discardableResult
    func maxBytes(count: Int) -> BaseTextView {
        maxBytes = count
        return self
    }
    
    @discardableResult
    func textDidChange(handler: @escaping TextDidChangeResponse) -> BaseTextView {
        textDidChangeHandler = handler
        return self
    }
    
    @discardableResult
    func didBeginEditing(handler: @escaping TextStateResponse) -> BaseTextView {
        didBeginEditingHandler = handler
        return self
    }
    
    @discardableResult
    func didEndEditing(handler: @escaping TextStateResponse) -> BaseTextView {
        didEndEditingHandler = handler
        return self
    }
    
    // MARK: - Update UI
    fileprivate func togglePlaceholderLabelBy(text: String) {
        guard let label = textHintLabel else { return }
        let isHidden = text != ""
        label.isHidden = isHidden
        if !isHidden { bringSubviewToFront(label) }
    }
}

extension BaseTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Check to show or hide placeholder label
        togglePlaceholderLabelBy(text: textView.text)
        textDidChangeHandler?(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if let maxCharCount = maxCharCount {
            return newText.count <= maxCharCount
        } else if let maxBytes = maxBytes, let currentBytes = newText.getBytesBy(encoding: SystemInfo.shiftJISEncoding) {
            return currentBytes <= maxBytes
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditingHandler?()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditingHandler?()
    }
}
