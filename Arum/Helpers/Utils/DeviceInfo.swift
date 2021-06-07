//
//  DeviceInfo.swift
//  Arum
//
//  Created by Admim on 6/6/21.
//

import Foundation
import UIKit

class DeviceInfo {
    var os: String {
        return UIDevice.current.systemName
    }
    
    var osVer: String {
        return UIDevice.current.systemVersion
    }
    
    var mobileBrand: String {
        return "Apple"
    }
    
    var mobileModel: String {
        return UIDevice.current.name
    }
    
    var lauchedBefore: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "lauchedBefore")
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "lauchedBefore")
        }
    }
    
    var fcmToken: String?
    
    static let shared = DeviceInfo()
    private init() {}
 
}

extension Bundle {
    func getAppVersion() -> String {
        guard let v = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return ""
        }
        return v
    }
}
