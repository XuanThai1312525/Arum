//
//  AppDelegate+Extension.swift
//  Arum
//
//  Created by TRINH.HO2 on 16/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func setupAppEnvironment(_ application:UIApplication,_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        registerNotification(application)
    }
    
    private func registerNotification(_ application:UIApplication) {
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
}

//MARK: Authentication Session
extension AppDelegate {
    func handleSession() {
        UserSession.roleSubject
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
//    목회자 / 01040862424
    func setupRootView(window: UIWindow, role: RoleAccess) {
        let vc: UIViewController
        switch(UserSession.roleSubject.value) {
            case .login:
                vc = SignInViewController(nib: R.nib.signInViewController)
            case .needToCheckDeviceID:
                vc = LoadingViewController()
                break
            case .needAuthentication:
                vc = AuthenticationViewController(nib: R.nib.authenticationViewController)
                break
            case .logged:
                vc = R.storyboard.main.arWebContentViewController()!
                break
        }
        
        let rootViewController = BaseNavigationVC(rootViewController:  vc)
        window.rootViewController = rootViewController
    }
    
    
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return false
    }
    
}
