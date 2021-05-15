//
//  KeychainWrapper.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainWrapper: NSObject {
    
    private let kKeychainItemIdentifier = "com.appdoctor.lane4"
    private var keychainAccess:Keychain!
    
    override init() {
        super.init()
        keychainAccess = Keychain(service: kKeychainItemIdentifier)
    }
    
    func removeAllData() {
        try? keychainAccess.removeAll()
    }
    
    func setObject(_ object: String?, forKey key: String) {
        guard let object = object else {
            return
        }
        try? keychainAccess.accessibility(.always).set(object, key: key)
    }
    
    func getObject(forKey key: String) -> String? {
        do {
            return try keychainAccess.get(key)
        } catch {
            return nil
        }
    }
    
}

