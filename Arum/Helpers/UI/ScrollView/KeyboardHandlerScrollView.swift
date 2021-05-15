//
//  KeyboardHandlerScrollView.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

typealias KeyboardFrameResponse = ((_ frame: CGRect) -> Void)
enum KeyboardPresenterStates {
    case willShow, didShow, willHide, didHide
}

class KeyboardHandlerScrollView: UIScrollView {
    
    // MARK: - Variables
    var changeInsetsWhenKeyboardWillShow = true {
        didSet {
            changeInsetsWhenKeyboardDidShow = !changeInsetsWhenKeyboardWillShow
        }
    }
    var changeInsetsWhenKeyboardDidShow = false {
        didSet {
            changeInsetsWhenKeyboardWillShow = !changeInsetsWhenKeyboardDidShow
        }
    }
    var changeInsetsWhenKeyboardWillHide = true {
        didSet {
            changeInsetsWhenKeyboardDidHide = !changeInsetsWhenKeyboardWillHide
        }
    }
    var changeInsetsWhenKeyboardDidHide = false {
        didSet {
            changeInsetsWhenKeyboardWillHide = !changeInsetsWhenKeyboardDidHide
        }
    }
    var tapToEndEditing = true
    private var lastInsetBottom: CGFloat = 0
    
    // MARK: - Closure
    var keyboardWillShow: KeyboardFrameResponse?
    var keyboardDidShow: KeyboardFrameResponse?
    var keyboardWillHide: KeyboardFrameResponse?
    var keyboardDidHide: KeyboardFrameResponse?
    
    // MARK: - Init & deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Builder
    @discardableResult
    func willShow(handler: @escaping KeyboardFrameResponse) -> KeyboardHandlerScrollView {
        keyboardWillShow = handler
        return self
    }
    
    @discardableResult
    func didShow(handler: @escaping KeyboardFrameResponse) -> KeyboardHandlerScrollView {
        keyboardDidShow = handler
        return self
    }
    
    @discardableResult
    func willHide(handler: @escaping KeyboardFrameResponse) -> KeyboardHandlerScrollView {
        keyboardWillHide = handler
        return self
    }
    
    @discardableResult
    func didHide(handler: @escaping KeyboardFrameResponse) -> KeyboardHandlerScrollView {
        keyboardDidHide = handler
        return self
    }
    
    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupScrollView()
        detectKeyboardStates()
        setupGestures()
    }
    
    // MARK: - Setup
    private func setupScrollView() {
        contentInset = .zero
        changeInsetsWhenKeyboardWillShow = true
        changeInsetsWhenKeyboardWillHide = true
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapGesture(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action
    func detectKeyboardStates() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(noti:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHideNotification(noti:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShowNotification(noti: Notification) {
        guard changeInsetsWhenKeyboardWillShow else { return }
        lastInsetBottom = contentInset.bottom
        let keyboardRect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        keyboardWillShow?(keyboardRect)
    }
    
    @objc private func keyboardDidShowNotification(noti: Notification) {
        guard changeInsetsWhenKeyboardDidShow else { return }
        lastInsetBottom = contentInset.bottom
        let keyboardRect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height, right: 0)
        keyboardDidShow?(keyboardRect)
    }
    
    @objc private func keyboardWillHideNotification(noti: Notification) {
        guard changeInsetsWhenKeyboardWillHide else { return }
        let keyboardRect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: lastInsetBottom, right: 0)
        keyboardWillHide?(keyboardRect)
    }
    
    @objc private func keyboardDidHideNotification(noti: Notification) {
        guard changeInsetsWhenKeyboardDidHide else { return }
        let keyboardRect = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: lastInsetBottom, right: 0)
        keyboardDidHide?(keyboardRect)
    }
    
    @objc private func scrollViewTapGesture(sender: UITapGestureRecognizer) {
        if tapToEndEditing { endEditing(true) }
    }
}
