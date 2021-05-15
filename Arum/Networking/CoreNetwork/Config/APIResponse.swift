//
//  APIResponse.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

// Define response data types for each request
public enum APIResponse {
    case success(_: JSON)
    case error(_: APIError)
    
    init(_ response: AFDataResponse<Any>, fromRequest request: APIRequest) {
        // Get status code
        let statusCode = response.response?.statusCode
        
//        if statusCode == 409 {
//            DispatchQueue.main.async {
//                IndicatorViewer.hide()
//                UIAlertController.showQuickSystemAlert(target: UIViewController.top(), title: "notification".localized, message: "common.session.expired".localized, cancelButtonTitle: "OK".localized) {
//                    let loginVC = LoginViewController.createWithNavigationController(storyBoard: Storyboard.Login.filename)
//                    UIApplication.shared.keyWindow?.rootViewController = loginVC
//                    return
//                }
//            }
//        }
        
        // Check if the request error exists
        if let error = response.error {
            self = .error(APIError.request(statusCode: statusCode, error: error))
            return
        }
        
        // Check if response has data or not
        guard let jsonData = response.data else {
            self = .error(APIError.request(statusCode: statusCode, error: response.error))
            return
        }
        
        // Try to parse api error if possible
        let json: JSON = JSON(jsonData)
        if let error = APIError.parseAPIErrorFrom(json: json, statusCode: statusCode) {
            self = .error(error)
            return
        }
        
        // Get data successfully
        self = .success(json)
    }
}

// Model repsonse protocol based on JSON data (View Controller's layers are able to view this protocol as response data)
public protocol APIResponseProtocol {
    // Set json as input variable
    init(json: JSON)
}

extension APIResponseProtocol {
    static func validateResponse(json: JSON) -> Bool {
        let status = json["typeUpdate"].intValue
        if status == 2 {
            return false
        }
        return true
    }
}
