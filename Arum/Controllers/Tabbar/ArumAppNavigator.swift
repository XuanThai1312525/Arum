//
//  ArumAppNavigator.swift
//  Arum
//
//  Created by Admim on 6/3/21.
//

import Foundation
import UIKit

class ArumAppNavigator {
    var window: UIWindow?
    var mainNavi: UINavigationController!
    let navigationQueue = DispatchQueue(label: "ai.earable.navigator.navigate")
    
    func startup(_ win: UIWindow?) {
        window = win
        mainNavi = (win?.rootViewController as? UINavigationController)!
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .clear
        navigationBarAppearace.barTintColor = .clear
        mainNavi.interactivePopGestureRecognizer?.isEnabled = false
    }
}

enum NavigationType {
    case push
    case present(UIModalPresentationStyle)
    case pop
    case popToRoot
    case dismiss
    case unknown
}

final class NavigationContext {
    var fromVC: UIViewController?
    var toVC: UIViewController?
    var type = NavigationType.unknown
    var animated = true
    var afterSec = 0.0
    var data: Any?
    var afterSecondsCompletion: (() -> Void)?
    var completion: (() -> Void)?
    var prepareData: ((NavigationContext) -> Void)?
    
    @discardableResult
    func completion(_ compl: (() -> Void)?) -> NavigationContext {
        completion = compl
        return self
    }
    
    
    @discardableResult
    func prepareData(_ prepare: ((NavigationContext) -> Void)?) -> NavigationContext {
        prepareData = prepare
        return self
    }
    
    @discardableResult
    func data(_ d: Any?) -> NavigationContext {
        data = d
        return self
    }
    
    @discardableResult
    func animated(_ animate: Bool) -> NavigationContext {
        animated = animate
        return self
    }
    
    @discardableResult
    func afterSec(_ sec: Double) -> NavigationContext {
        afterSec = sec
        return self
    }
    
    @discardableResult
    func toVC(_ vc: UIViewController?) -> NavigationContext {
        toVC = vc
        return self
    }
    
    @discardableResult
    func fromVC(_ vc: UIViewController?) -> NavigationContext {
        fromVC = vc
        return self
    }
    
    @discardableResult
    func type(_ t: NavigationType) -> NavigationContext {
        type = t
        return self
    }
    
    deinit {
//        print("NavigationViewControllerContext deinit")
    }
}

extension ArumAppNavigator {
    func navigateViewController(_ context: NavigationContext) {
        if context.afterSec > 0.0 {
            navigationQueue.asyncAfter(deadline: DispatchTime.now() + context.afterSec) {
                DispatchQueue.main.sync { [weak self] in
                    guard let `self` = self else {return}
                    context.afterSecondsCompletion?()
                    self.navigateViewController(context.afterSec(0.0))
                }
            }
            return
        } else if !Thread.isMainThread {
            DispatchQueue.main.sync { [weak self] in
                guard let `self` = self else {return}
                self.navigateViewController(context)
            }
            return
        }
        
        switch context.type {
        case .push:
            guard let fromViewController = context.fromVC else {break}
            guard let toViewController = context.toVC else {break}
            if let navi = fromViewController as? UINavigationController {
                // prevent crash when tried to push a certain Navigation Controller, or push a pushed vc
                guard toViewController.navigationController == nil, !(toViewController.self is UINavigationController) else {break}
                navi.pushViewController(toViewController, animated: context.animated)
            } else {
                fromViewController.show(toViewController, sender: nil)
            }
            guard context.animated else {break}
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
                context.completion?()
            }
            
        case let .present(type):
            guard let fromViewController = context.fromVC else {
//                context.errorCompletion?(.none)
                break
            }
            guard let toViewController = context.toVC else {
//                context.errorCompletion?(.none)
                break
            }
            // prevent crash when tried to prensent a presented vc
            guard toViewController.presentingViewController == nil else {
//                context.errorCompletion?(.none)
                break
            }
            toViewController.modalPresentationStyle = type
            fromViewController.present(toViewController, animated: context.animated, completion: context.completion)
            
        case .pop:
            var _navi: UINavigationController?
            if let nv = context.fromVC as? UINavigationController {
                _navi = nv
            } else if let nv = context.fromVC?.navigationController {
                _navi = nv
            }
            guard let navi = _navi else {break}
            if let toVC = context.toVC {
                navi.popToViewController(toVC, animated: context.animated)
            } else {
                navi.popViewController(animated: context.animated)
            }
            guard context.animated else {break}
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
                context.completion?()
            }
            
        case .popToRoot:
            guard let navi = context.fromVC as? UINavigationController else {break}
            navi.popToRootViewController(animated: context.animated)
            guard context.animated else {break}
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
                context.completion?()
            }
            
        case .dismiss:
            guard let fromViewController = context.fromVC else {break}
            (fromViewController.navigationController ?? fromViewController)?.dismiss(animated: context.animated, completion: context.completion)
            
        default:
            break
        }
    }
}

