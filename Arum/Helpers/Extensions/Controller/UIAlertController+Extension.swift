//
//  UIAlertController+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import Foundation
import UIKit

typealias SystemAlertButtonData = (title: String, style: UIAlertAction.Style, handler: (() -> Void)?)

// Extension for system alert view
extension UIAlertController {
    static func showQuickSystemAlert(target: UIViewController? = UIViewController.top(),
                                     title: String? = nil,
                                     message: String? = nil,
                                     cancelButtonTitle: String = "ok".localized,
                                     handler: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
            handler?()
        }))
        target?.present(alertVC, animated: true)
    }
    
    static func showSystemAlert(target: UIViewController? = UIViewController.top(),
                                title: String? = nil,
                                message: String? = nil,
                                buttons: [String],
                                handler: ((_ index: Int, _ title: String) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.enumerated().forEach { button in
            let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
                handler?(button.offset, button.element)
            })
            alert.addAction(action)
        }
        target?.present(alert, animated: true)
    }
    
    static func showSystemAlert(target: UIViewController? = UIViewController.top(),
                                title: String? = nil,
                                message: String? = nil,
                                buttons: [SystemAlertButtonData]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.forEach { button in
            let action = UIAlertAction(title: button.title, style: button.style, handler: { _ in
                button.handler?()
            })
            alert.addAction(action)
        }
        target?.present(alert, animated: true)
    }
    
    static func showSystemActionSheet(target: UIViewController? = UIViewController.top(),
                                      title: String? = nil,
                                      message: String? = nil,
                                      optionButtons: [SystemAlertButtonData],
                                      cancelButton: SystemAlertButtonData) {
        let viewBG = UIView(frame: UIScreen.main.bounds)
        let backgroundColor = UIColor.black.withAlphaComponent(0.6)
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        optionButtons.forEach { (button) in
            alert.addAction(UIAlertAction(title: button.title, style: button.style, handler: { (_) in
                viewBG.removeFromSuperview()
                button.handler?()
            }))
        }
        let cancelAction = UIAlertAction(title: cancelButton.title, style: UIAlertAction.Style.cancel, handler: { (_) in
            viewBG.removeFromSuperview()
            cancelButton.handler?()
        })
        alert.addAction(cancelAction)
        viewBG.backgroundColor = backgroundColor
        target?.view.addSubview(viewBG)
        target?.present(alert, animated: true)
    }
    
    
    static func showAlertWith(target: UIViewController? = UIViewController.top(),
                              title: String? = nil,
                              message: String? = nil,
                              okButtonTitle: String? = nil,
                              cancelButtonTitle: String = "ok".localized,
                              cancelHandler: (() -> Void)? = nil,
                              okButtonHandler:(() -> Void)? = nil ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if okButtonTitle != nil {
            alertVC.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: { _ in
                okButtonHandler?()
            }))
        }
        
        alertVC.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in
            cancelHandler?()
        }))
        
        target?.present(alertVC, animated: true)
    }
}
