//
//  AppDelegate+Environment.swift
//  Arum
//
//  Created by trinhhc on 6/1/21.
//

import Firebase
import IQKeyboardManagerSwift
import GoogleMobileAds

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func setupAppEnvironment(_ application:UIApplication,_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        FirebaseApp.configure()
        registerNotification(application)
        registerFirebaseMessage(launchOptions)
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        application.applicationIconBadgeNumber = 0
    }
}

