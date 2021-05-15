//
//  APIUtilities.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import Alamofire

class APIUtilities {
    
    // MARK: - Singleton
    static let instance = APIUtilities()
    
    // MARK: - Variables
    private var reachabilityManager: NetworkReachabilityManager?
    
    // MARK: - Supporting functions
    static var hasInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func startDetectingInternetStatusChanged() {
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .reachable:
                print("Co mang")
            case .notReachable:
                print("Khong co mang")
            case .unknown:
                print("Khong biet")
            }
        })
    }
}
