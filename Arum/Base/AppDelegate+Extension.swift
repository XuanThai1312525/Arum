//
//  AppDelegate+Extension.swift
//  Arum
//
//  Created by TRINH.HO2 on 16/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
extension AppDelegate {
    
    func setupAppEnvironment(_ application:UIApplication,_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        
    }
    
}

//MARK: Authentication Session
extension AppDelegate {
    func handleSession() {
        UserSession.shared.roleSubject
            .share()
            .subscribe(onNext: { [weak self] role in
                guard let self = self else {
                    return
                }
                
                if let window = AppDelegate.shared.window {
                    let options: UIView.AnimationOptions = .transitionFlipFromLeft
                    UIView.transition(with: window, duration: 0.3, options: options, animations: {
                        self.setupRootView(window: window, role: role)
                    })
                } else {
                    AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
                    let window = AppDelegate.shared.window!
                    self.setupRootView(window: window, role: role)
                    window.makeKeyAndVisible()
                }
            })
            .disposed(by: bag)
    }
    
    func setupRootView(window: UIWindow, role: RoleAccess) {
        guard let window = AppDelegate.shared.window else {
            return
        }
        
        let rootViewController = BaseNavigationVC(rootViewController:  SignInViewController(nib: R.nib.signInViewController))
        
        //        switch(role) {
        //            case .logged:
        //                rootViewController = R.storyboard.baseTabbar.instantiateInitialViewController()
        //            case .login:
        //                rootViewController = R.storyboard.startViewController.startViewController()
        //
        //        }
        
        //Every case missing handle above will be fall in login
        //        if rootViewController == nil {
        //            let vc = R.storyboard.startViewController.startViewController()
        //            rootViewController = vc
        //        }
        //
        
        
        window.rootViewController = rootViewController
    }
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return false
    }
    
}
