//
//  OptionalExtension.swift
//  Arum
//
//  Created by trinhhc on 5/20/21.
//

import Foundation
import UIKit
public extension Dictionary where Key == String, Value == Any {
  func string(key: String,defaultValue: String ) -> String {
    return self[key].defaultString(defaultValue)
  }
  
  func int(key: String,defaultValue: Int ) -> Int {
    return self[key].defaultInt(defaultValue)
  }
  
  func bool(key: String,defaultValue: Bool ) -> Bool {
    return self[key].defaultBool(defaultValue)
  }
  
  func cgFloat(key: String,defaultValue: CGFloat ) -> CGFloat {
    return self[key].defaultCGFloat(defaultValue)
  }
  
  func array(key: String,defaultValue:[Any]) -> [Any]{
    return  self[key].defaultArray(defaultValue)
  }
  
  func float(key: String,defaultValue: Float ) -> Float {
      return self[key].defaultFloat(defaultValue)
  }
}

extension Optional where Wrapped == Any {
  
  func defaultString(_ value: String = "") -> String{
    return self as? String ?? value
  }
  
  func defaultInt(_ value: Int = 0) -> Int {
    return self as? Int ?? value
  }
  
  func defaultBool(_ value: Bool = false) -> Bool {
    return self as? Bool ?? value
  }
  
  func defaultCGFloat(_ value: CGFloat = 0.0) -> CGFloat {
    return self as? CGFloat ?? value
  }
  
  func defaultArray(_ value: [Any] = []) -> [Any] {
    return self as? [Any] ?? value
  }
  
  func defaultFloat(_ value: Float)-> Float {
    return self as? Float ?? value
  }
}

extension Optional where Wrapped == String {
    var emptyOnNil: String { 
      return self ?? ""
    }
}
