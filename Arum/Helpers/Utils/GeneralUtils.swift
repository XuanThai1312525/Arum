//
//  GeneralUtils.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
import UIKit
class GeneralUtils {
    // Get/set value for app icon badge value
       static var appIconValue: Int {
           get {
               return UIApplication.shared.applicationIconBadgeNumber
           }
           set(value) {
               UIApplication.shared.applicationIconBadgeNumber = value
           }
       }
       
       // Main queue
       static func mainQueue(closure: @escaping () -> Void) {
           DispatchQueue.main.async {
               closure()
           }
       }
       
       // Sleep app with input time interval
       static func sleep(_ second: TimeInterval, completion: @escaping (() -> Void)) {
           DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: {
               completion()
           })
       }
       
       static func openUrl(string: String) {
           guard let url = URL(string: string) else { return }
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       }
       
       static func openAppOnAppStore() {
           guard let url = SystemInfo.appInfoOnAppStoreUrl else { return }
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
       }
       
       static func needToUpdateAppWith(remoteVersion: String) -> Bool {
           guard let currentVersion = SystemInfo.appVersion else { return false }
           return remoteVersion.compare(currentVersion, options: .numeric) == .orderedDescending
       }
}
