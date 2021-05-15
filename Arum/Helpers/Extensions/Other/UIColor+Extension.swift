//
//  UIColor+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

// MARK: - General methods
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
   
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    func alpha(_ value: CGFloat) -> UIColor {
        return self.withAlphaComponent(value)
    }
}


extension UIColor {
    static let colorBlue = UIColor(named: "color-blue-btn")
    static let colorErrorLightRed = UIColor(named: "color-error-bg")
    static let colorErrorRedText = UIColor(named: "color-error-text")
    static let colorLightGray = UIColor(named: "color-light-gray")
    static let colorNavyBlue = UIColor(named: "color-navy-text")
    static let colorOrangeBorder = UIColor(named: "color-orange-border")
    static let colorYellowBg = UIColor(named: "color-yellow-bg")
    static let colorBGView = UIColor(named: "color-background-view")
    static let colorSeperator = UIColor(named: "color-seperator")
    static let colorLightYellow = UIColor(named: "color-light-yellow")
    static let borderBlueColor = UIColor(hex: "1499fd")
    static let greenCheckBoxColor = UIColor(named: "ColorTextFinishStepD53")
    static let backgroundButtonStep4 = UIColor(named: "backgroundButtonStep4")
    static let ColorNumberStepFF2 = UIColor(named: "ColorNumberStepFF2")
    static let colordisableBtn = UIColor(named: "color-disable-btn")
}
