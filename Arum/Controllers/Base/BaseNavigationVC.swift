//
//  BaseNavigationVC.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
import UIKit
class BaseNavigationVC: UINavigationController {
        
   // MARK: - Private Properties

   private var duringPushAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: true)
    }
    
    // MARK: - UINavigationControllerDelegate
}
    extension BaseNavigationVC: UINavigationControllerDelegate {

        
        func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
            guard let swipeNavigationController = navigationController as? BaseNavigationVC else { return }

            swipeNavigationController.duringPushAnimation = false
        }

    }

    // MARK: - UIGestureRecognizerDelegate

    extension BaseNavigationVC: UIGestureRecognizerDelegate {

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard gestureRecognizer == interactivePopGestureRecognizer else {
                return true // default value
            }

            // Disable pop gesture in two situations:
            // 1) when the pop animation is in progress
            // 2) when user swipes quickly a couple of times and animations don't have time to be performed
            return viewControllers.count > 1 && duringPushAnimation == false
        }
    }


