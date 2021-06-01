//
//  Network+Ex.swift
//  Arum
//
//  Created by trinhhc on 5/25/21.
//

import SwiftyJSON

extension JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

extension NSError {
  static func getError(message: String) -> NSError{
    return NSError(domain: "CUSTOM_BUSINESS_ERROR", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: message])
  }
 
  static func getDefaultError() -> NSError{
    getError(message: "何らかのエラーが発生しました。 後でお試しください")
  }
}

extension Error {
  var code: Int { return (self as NSError).code }
  var userInfo: [String: Any] { return (self as NSError).userInfo }
  var domain: String { return (self as NSError).domain }
  var localizedFailureReason: String? { return (self as NSError).localizedFailureReason }
  var localizedRecoverySuggestion: String? { return (self as NSError).localizedRecoverySuggestion }
  var localizedRecoveryOptions: [String]? { return (self as NSError).localizedRecoveryOptions }
  var recoveryAttempter: Any? { return (self as NSError).recoveryAttempter }
  var helpAnchor: String? { return (self as NSError).helpAnchor }
 
}
