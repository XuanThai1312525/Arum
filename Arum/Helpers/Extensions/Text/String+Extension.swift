//
//  String+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import CommonCrypto

// General enum list
enum RandomStringType: String {
    case numericDigits = "0123456789"
    case uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    case allKindLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case numericDigitsAndLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var text: String { return rawValue }
}

extension String {
    // MARK: - Subscript
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    // MARK: - Variables
    var int: Int? {
        return Int(self)
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    var image: UIImage? {
        return UIImage(named: self)
    }
    
    var localized: String {
        return LocalizationManager.shared.localizedString(forKey: self, value: "") ?? self
    }
    

    
    var percentEncoding: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var trimWhiteSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var trimNewLines: String {
        return self.trimmingCharacters(in: .newlines)
    }
    
    var trimWhiteSpacesAndNewLines: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var md5: String? {
        guard let messageData = self.data(using:.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
//    var encryptAES: String? {
//        let key = "mwLZH3hyy6jKR0AP"
//        let iv = "FWmn6Yu5KXPUKZrp"
//        do {
//            if let data = self.data(using: .utf8) {
//                let encrypted = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).encrypt([UInt8](data))
//                let encryptedString = Data(encrypted).base64EncodedString()
//                return encryptedString
//            }
//        } catch { }
//        return nil
//    }

//    var decryptAES: String? {
//        let key = "mwLZH3hyy6jKR0AP"
//        let iv = "FWmn6Yu5KXPUKZrp"
//        do {
//            if let data = Data(base64Encoded: self) {
//                let decrypted = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).decrypt([UInt8](data))
//                let decryptedString = String(bytes: Data(decrypted).bytes, encoding: .utf8)
//                return decryptedString
//            }
//        } catch { }
//        return nil
//    }
    
    var hasSpecialCharacters: Bool {
        let regex = "(?=.*[A-Za-z0-9]).{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var isEmail: Bool {
        let regex = "^(([\\w+-]+\\.)+[\\w+-]+|([a-zA-Z+]{1}|[\\w+-]{2,}))@((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        if self.contains("-") || self.contains("*") || self.contains("+") {
            let precidate = NSPredicate(format: "SELF MATCHES %@", "^((\\+)|(00))[0-9]{6,14}$")
            return precidate.evaluate(with: self)
        }
        let precidate = NSPredicate(format: "SELF MATCHES %@", "([0-9]){10,11}$")
        return precidate.evaluate(with: self)
    }
    
    // Vietnamese phone pattern
    var isPhone: Bool {
        return evaluateRegex("^(3[23456789]|5[689]|7[06789]|8[12345689]|9[012346789])([0-9]{7})$")
    }
    
    var phoneNoFormat: String {
        var trim = self.replacingOccurrences(of: " ", with: "")
        trim.insert("0", at: trim.startIndex)
        return trim
    }
    
    func evaluateRegex(_ regex: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with:self)
    }
    
    func isValidPassword() -> Bool {
        let passRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d\\d$]{8,20}"//"^(?=(?:[a-zA-Z0-9]*[a-zA-Z]){2})(?=(?:[a-zA-Z0-9]*\\d){2})[a-zA-Z0-9]{8,20}$" //"^(?=.*\\d)(?=.*[a-zA-Z]).{8,}$"
        //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,20}"
        return evaluateRegex(passRegex)
    }
    
    func checkUpperCasedStringValidation() -> Bool {
         let capitalLetterRegEx  = ".*[A-Z]+.*"
        return evaluateRegex(capitalLetterRegEx)
    }
    
    func checkLowerCasedStringValidation() -> Bool {
         let capitalLetterRegEx  = ".*[a-z]+.*"
        return evaluateRegex(capitalLetterRegEx)
    }
    
    func checkNumericStringValidation() -> Bool {
         let capitalLetterRegEx  = ".*[0-9]+.*"
        return evaluateRegex(capitalLetterRegEx)
    }
    
    func isValidatedPassowrdType() -> ValidatePasswordError {
        if !self.isValidPassword() {
            
            if self.isEmpty {
                return .EmptyPasswordError
            }
            
            if !self.checkUpperCasedStringValidation() {
                return .captitalLetterError
            }
            
            if !self.checkLowerCasedStringValidation() {
                return .smallLetterError
            }
            
            if !self.checkNumericStringValidation() {
                return .numericError
            }
            
            return .PassowrdLengthError
        }
        
        return .ValidPassword
    }
    
    
    
    
    var isFullSizeCharacter: Bool {
        return getBytesBy(encoding: SystemInfo.shiftJISEncoding) == 2
    }

    // MARK: - Static functions
    static func randomStringWith(type: RandomStringType, length: Int) -> String {
        let letters: NSString = type.text as NSString
        let len = UInt32(letters.length)
        var randomString = ""
        (0..<length).forEach { _ in
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    static func add(separator text: String = ",", to number: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = text
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    // MARK: - Local functions
    func first(_ length: Int) -> String {
        return String(self.prefix(length))
    }
    
    func last(_ length: Int) -> String {
        return String(self.suffix(length))
    }
    
    func startIndex(of subString: String) -> Int? {
        if let range = self.range(of: subString) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func endIndex(of subString: String) -> Int? {
        if let range = self.range(of: subString, options: .backwards) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func getBytesBy(encoding: String.Encoding) -> Int? {
        return data(using: encoding)?.count
    }
    
    func replace(string: String, with newString: String) -> String {
        return self.replacingOccurrences(of: string, with: newString)
    }
    
    func nsrangeOf(subString: String) -> NSRange? {
        if let range = self.range(of: subString) {
            return NSRange(range, in: self)
        }
        return nil
    }
    
    func numberBy(removing separator: String) -> Int {
        let seperatedArr = components(separatedBy: separator)
        var finalNumber = 0
        for (i, numStr) in seperatedArr.reversed().enumerated() {
            if let dNum = Int(numStr) {
                finalNumber += dNum * Int(pow(10, Double(i)))
            }
        }
        return finalNumber
    }
    
    func dateBy(format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }

    func textBoundsWith(width: CGFloat, font: UIFont) -> CGRect {
        let st = self as NSString
        return st.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                               options: .usesLineFragmentOrigin,
                               attributes: [.font: font],
                               context: nil)
    }
    
    func textBoundsWith(height: CGFloat, font: UIFont) -> CGRect {
        let st = self as NSString
        return st.boundingRect(with: CGSize(width: CGFloat(CGFloat.greatestFiniteMagnitude), height: height),
                               options: .usesLineFragmentOrigin,
                               attributes: [.font: font],
                               context: nil)
    }
    
    func heightWith(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func widthWith(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}



/// MARK: Extenstion for phone number
extension String {
    private func makeOnlyDigitsString(string: String) -> String {
        return string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func formatPhone(prefix: String? = nil) -> String {
        // remove prefix
        let text = self.deletingPrefix("+84")
        
        let tempString = makeOnlyDigitsString(string: text)
        let formattingPattern9 = "** *** ****"
        let formattingPattern10 = "*** *** ****"
        let replacementChar: Character = "*"
        let prefixPhoneChar: Character = "0"
        
        var finalText = ""
        var stop = false
        
        let format = text.first == prefixPhoneChar ? formattingPattern10 : formattingPattern9
        var formatterIndex = format.startIndex
        var tempIndex = tempString.startIndex
        
        while !stop {
            let formattingPatternRange = formatterIndex ..< format.index(formatterIndex, offsetBy: 1)
            if format[formattingPatternRange] != String(replacementChar) {
                finalText = finalText + format[formattingPatternRange]
            } else if tempString.count > 0 {
                let pureStringRange = tempIndex ..< tempString.index(tempIndex, offsetBy: 1)
                finalText = finalText + tempString[pureStringRange]
                tempIndex = tempString.index(after: tempIndex)
            }
            
            formatterIndex = format.index(after: formatterIndex)
            
            if formatterIndex >= format.endIndex || tempIndex >= tempString.endIndex {
                stop = true
            }
        }
        return (prefix ?? "") + finalText
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func isNumeric() -> Bool {
        guard count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    func convert(fromOriginFormat date1: String, toResultFormat date2: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = date1
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        guard let date = dateFormatter.date(from: self) else { return nil }
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = date2
        newDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return newDateFormatter.string(from: date)
    }
}
