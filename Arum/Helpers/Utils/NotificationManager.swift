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
        
        if UserSession.roleSubject.value == .logged , let userInfo = NotificationManager.userInfo{
            handleNotification(userInfo: userInfo)
            NotificationManager.userInfo = nil
        }
        
        //Force clear badge
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    static func handleNotification(userInfo: [String: Any]){
        guard let aps = userInfo["aps"] as? [String: Any],
              let click_action = aps["category"] as? String
        else {
            return
        }
        
        guard let nav = AppDelegate.shared.window.rootViewController as? BaseNavigationVC else {
            return
        }
        
        if let vc = nav.viewControllers.last(where: {$0.isKind(of: ARWebContentViewController.self)}) as? ARWebContentViewController {
            vc.urlString = click_action
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                nav.rootViewController?.pop(to: vc)
            }
        } else {
            //Block code
//            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "ARWebContentViewController") as! ARWebContentViewController
//            vc.urlString = click_action
//            nav.pushViewController(vc, animated: true)
//
            
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "ARWebContentViewController") as! ARWebContentViewController
            vc.urlString = Constants.BASE_URL
            
            nav.pushViewController(vc, animated: true)
            
            //Please don't open click action force. because cannot touch go back
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                vc.urlString = click_action
                
            }
            
        }
        
    }
}
