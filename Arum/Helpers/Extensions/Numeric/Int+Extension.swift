//
//  Int+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//
import Foundation

extension Int {
    func string() -> String {
        return "\(self)"
    }
    
    func addCommaWith(separator: String = ",") -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = separator
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))
    }
}



extension TimeInterval{
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        //let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600) % 24
        let day = time / 86400
        if day > 0 {
            return String(format: "%0.2d %0.2d:%0.2d:%0.2d",day,hours,minutes,seconds)
        }
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        
    }
}
