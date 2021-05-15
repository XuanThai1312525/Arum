//
//  NotificationPermission.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationPermission {
    
    // MARK: - Static variables
    static func getAuthorizationStatus(completion: @escaping ((_ status: UNAuthorizationStatus) -> Void)) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { settings in
            completion(settings.authorizationStatus)
        })
    }
}
