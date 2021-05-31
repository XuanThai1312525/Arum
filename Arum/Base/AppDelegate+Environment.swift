//
//  AppDelegate+Environment.swift
//  Arum
//
//  Created by trinhhc on 6/1/21.
//

import Firebase

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func setupAppEnvironment(_ application:UIApplication,_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FirebaseApp.configure()
        registerNotification(application)
        registerFirebaseMessage(launchOptions)
    }
}

