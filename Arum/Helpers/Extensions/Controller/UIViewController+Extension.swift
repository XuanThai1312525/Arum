//
//  UIViewController+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import Foundation
import UIKit

protocol XibViewController {
    static var name: String { get }
    static func create(storyBoard: String?) -> Self
}

extension XibViewController where Self: UIViewController {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func create(storyBoard: String? = nil) -> Self {
        
        if let storyboardName = storyBoard,  storyboardName.count > 0 {
            let nibName = storyboardName
            let storyboard = UIStoryboard(name: nibName, bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: self.name) as! Self
        } else {
            return self.init(nibName: Self.name, bundle: nil)
        }
    }
    
    static func createWithNavigationController(storyBoard: String? = nil) -> UINavigationController {
        let vc = create(storyBoard: storyBoard)
        let navController = BaseNavigationVC(rootViewController: vc)
        return navController
    }
    
    static func present(from: UIViewController? = top(),
                        animated: Bool = true,
                        prepare: ((_ vc: Self) -> Void)? = nil,
                        completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        parentVC.present(targetVC, animated: animated, completion: completion)
    }
    
    static func push(from: UIViewController? = top(),
                     animated: Bool = true,
                     prepare: ((_ vc: Self) -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        parentVC.navigationController?.pushViewController(targetVC, animated: animated)
        CATransaction.commit()
    }
    
    

}

extension UIViewController: XibViewController { }

extension UIViewController {
    
    func addViewController(vc: UIViewController, viewBase: UIView){
        vc.willMove(toParent: self)
        self.addChild(vc)
        viewBase.addSubview(vc.view)
        vc.didMove(toParent: self)
        vc.view.frame = CGRect(x: 0, y: 0, width: viewBase.bounds.width, height: viewBase.bounds.height)
    }
    
    var name: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    var isModal: Bool {
        if let navController = self.navigationController, navController.viewControllers.first != self {
            return false
        }
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    var isVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
    }

    class func top(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return top(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return top(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return top(controller: presented)
        }
        return controller
    }
    
    func dismissToRoot(controller: UIViewController? = UIViewController.top(),
                       animated: Bool = true,
                       completion: ((_ rootVC: UIViewController?) -> Void)? = nil) {
        guard let getController = controller else {
            completion?(nil)
            return
        }
        if let prevVC = getController.presentingViewController {
            if prevVC.isModal && prevVC.presentingViewController != nil {
                dismissToRoot(controller: prevVC, animated: animated, completion: completion)
            } else {
                getController.dismiss(animated: animated, completion: {
                    completion?(prevVC)
                })
            }
        } else {
            completion?(getController)
        }
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    class func topViewController(controller: UIViewController? = AppDelegate.shared.window?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    static func topControllerIs<T: UIViewController>(_ type: T.Type) -> Bool {
        guard let topVC = topViewController() else { return false }
        return topVC.isKind(of: type)
    }
    

    

}

extension UIViewController {
    static func make<T: UIViewController>(_ type: T.Type) -> T {
        var sb: UIStoryboard?
        switch type {
        case is ARWebContentViewController.Type:
            sb = UIStoryboard.main
        default:
            break
        }
        return sb?.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    
    func inNavigation(_ navi: UINavigationController) -> Bool {
        return navigationController === navi
    }
    
    var previousViewController: UIViewController? {
        guard let navi = navigationController,
              let index = navi.viewControllers.lastIndex(of: self),
              index > 0 else {
            return nil
        }
        return navi.viewControllers[index - 1]
    }
}

extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
    
    func first<T: UIViewController>(where type: T.Type) -> T? {
        return viewControllers.first(where: { $0.self is T }) as? T
    }
    
    func last<T: UIViewController>(where type: T.Type) -> T? {
        return viewControllers.last(where: { $0.self is T }) as? T
    }
}

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

