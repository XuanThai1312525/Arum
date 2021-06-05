//
//  NotificationManager.swift
//  Arum
//
//  Created by trinhhc on 6/1/21.
//

import UIKit

class NotificationManager: NSObject {
    static var userInfo: [String: Any]?
    
    static func handlEventClickOnNotificationWhenAppTerminateToOpenAppIfNeed(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let launchingOptions = launchOptions, let userInfo = launchingOptions[.remoteNotification] as? [String: Any] {
            NotificationManager.userInfo = userInfo
        }
        
        
    }
    
    static func handleEventClickOnNotificationWhenAppInBackgroundOrForeGround(userInfo: [String: Any]) {
        handleNotificationIfNeed(userInfo: userInfo)
    }
    
    static func handleNotificationIfNeed(userInfo: [String: Any]?) {
        if let userInfo = userInfo {
            NotificationManager.userInfo = userInfo
        }
        
        if let userInfo = NotificationManager.userInfo{
            handleNotification(userInfo: userInfo)
            NotificationManager.userInfo = nil
        }
        
        //Force clear badge
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    static func handleNotification(userInfo: [String: Any]){
        guard let aps = userInfo["aps"] as? [String: Any],
              let data = aps["data"] as? [String: Any],
              let pushType = data["pushType"] as? Int
        else {
            return
        }
        
        switch pushType {
            case 1:
                
            break
        default:
            break
        }
        
    }
}
