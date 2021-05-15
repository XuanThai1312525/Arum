//
//  SystenInfo.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import UIKit

// MARK: - Screen information
class SystemInfo {
    static let screenBounds = UIScreen.main.bounds
    static var screenWidth: CGFloat{return UIScreen.main.bounds.width}
    static let screenHeight = UIScreen.main.bounds.height
    static let screenNativeBounds = UIScreen.main.nativeBounds
    static let screenNativeWidth = UIScreen.main.nativeBounds.width
    static let screenNativeHeight = UIScreen.main.nativeBounds.height
    
    static let iphone3point5InchesHeight: CGFloat = 480 // iphone 4s and below
    static let iphone4InchesHeight: CGFloat = 568 // iphone 4s -> iphone 5s || iphone SE
    static let iphone4point7InchesHeight: CGFloat = 667 // iphone 6 & 7 & 8
    static let iphone5point5InchesHeight: CGFloat = 736 // iphone 6+ & 7+ & 8+
    static let iphone5point8InchesHeight: CGFloat = 812 // iphone X
    static let iphone6point5InchesHeight: CGFloat = 896 // iphone XS Max
    
    
    static var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }else{
         return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
    
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    static var safeAreaInsetTop: CGFloat {
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0
    }
    static var safeAreaInsetBottom: CGFloat = {
        if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.keyWindow else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0
    }()

}

// MARK: - App general information
extension SystemInfo {
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let schemeName = ProcessInfo.processInfo.environment["targetName"] ?? ""
    static let osName = UIDevice.current.systemName
    static let osVersion = UIDevice.current.systemVersion
    static let uuid = UUID().uuidString
    static var bundleId: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    static let appIdOnAppStore: String = "1448686663"
    static var appInfoOnAppStoreUrl: URL? {
        let urlStr = String(format: "itms-apps://itunes.apple.com/app/bars/id%@", appIdOnAppStore)
        return URL(string: urlStr)
    }
    // Access app icon value
    class var appIconValue: Int {
        get { return UIApplication.shared.applicationIconBadgeNumber }
        set(value) { UIApplication.shared.applicationIconBadgeNumber = value }
    }
}

// MARK: - Other information
extension SystemInfo {
    static let shiftJISEncoding = String.Encoding.shiftJIS
    static let utf8Encoding = String.Encoding.utf8
}

func logFileName(name: String, line: Int) -> String {
    return (name.components(separatedBy: "/").last ?? "")+" "+line.description
}

