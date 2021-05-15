//
//  LocalizationManager.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation

public class LocalizationManager: NSObject {
    
    public static let shared = LocalizationManager()
    
    private var bundle: Bundle? = Bundle.main
    
    private override init() {
        super.init()
        if let path = Bundle.main.path(forResource: self.language, ofType: "lproj") {
            self.bundle = Bundle(path: path)
        }
    }
    
    public var language: String? {
        get {
             "vi"
        }
        set {
//            DataManager.shared.appLanguage = newValue ?? "vi"
            guard let path = Bundle.main.path(forResource: newValue, ofType: "lproj") else {
                self.resetLocalization()
                return
            }
            bundle = Bundle(path: path)
            NotificationCenter.default.post(name: CGLNotificationName.changeLanguage.value, object: nil)
        }
    }
    
    public func localizedString(forKey key: String, value: String) -> String? {
        return bundle?.localizedString(forKey: key, value: nil, table: nil)
    }
    
    public func resetLocalization() {
        bundle = Bundle.main
    }
    
}


public enum CGLNotificationName : String {
    case changeLanguage = "languageChange"
    case didSelectDocument = "didSelectDocument"
    case allDetailWayBillIsCompleted = "allDetailWayBillIsCompleted"
    case shouldUpdateStatusInforVC = "shouldUpdateStatusInforVC"
    case didStartNavigationMap = "didStartNavigationMap"
    case didStartNavigationMapWithAnnotation = "didStartNavigationMapWithAnnotation"
    case didChangeNoteValue = "didChangeNoteValue"
    case showSMSController = "showSMSController"
    
    public var value: Notification.Name {
        return Notification.Name(self.rawValue)
    }
}
