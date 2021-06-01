//
//  AppDelegate+Notification.swift
//  Arum
//
//  Created by trinhhc on 6/1/21.
//

import FirebaseMessaging

extension AppDelegate: MessagingDelegate {
    
    func registerFirebaseMessage(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Messaging.messaging().delegate = self
        NotificationManager.handlEventClickOnNotificationWhenAppTerminateToOpenAppIfNeed(launchOptions: launchOptions)
    }
    
    func registerNotification(_ application:UIApplication) {
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
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("firebase_token : ",fcmToken)
        UserSession.UUID_TOKEN = fcmToken
        UserDefaults.standard.setValue(fcmToken, forKey: "NOTIFICATION_DEVICE_TOKEN")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    //Display message when app in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    //Display message when app in background or foreground and click into notification to open app
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String: Any] {
            NotificationManager.handleEventClickOnNotificationWhenAppInBackgroundOrForeGround(userInfo: userInfo)
        }
        
        
        completionHandler()
    }
   
    //Receive silent notification
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
}
