//
//  DataManager.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private let keyChain: KeychainWrapper
    
    private init() {
            self.keyChain = KeychainWrapper()
        }
}
