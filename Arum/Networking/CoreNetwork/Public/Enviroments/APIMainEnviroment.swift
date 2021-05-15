//
//  MainEnviroment.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/18/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// MARK: - Request basic information
class APIConfiguration {

    // Base url of web service
    static var baseUrl: String {
        return ""
    }
    
    static var userHeaders: HTTPHeaders {
            return [:]
        }
        
    
    // HTTP Headers
    static var httpHeaders: HTTPHeaders {
        return [:]
    }
    
    static let timeout: TimeInterval = 30
    static let encoding: ParameterEncoding = URLEncoding.default
}

// MARK: - Handle supporting functions
extension APIConfiguration {
    static func parseAPIErrorFrom(_ json: JSON, statusCode: Int?) -> APIError? {
        // Try to parse input json to error class according to your error json format
        // Example:
        guard !json["error"].isEmpty else { return nil }
        let code = json["error"]["code"].intValue
        var message: String?
        if let apiMessages = json["error"]["message"].string {
            message = apiMessages
        } else {
            message = json["error"]["messages"].string
        }
        let error = APIError.api(statusCode: statusCode, apiCode: code, message: message)
        return error
    }
}

class APIMainEnviroment {
    
    var baseUrl: String
    
    var headers: HTTPHeaders
    
    var encoding: ParameterEncoding
    
    var timeout: TimeInterval
    
    class var `default`: APIMainEnviroment {
        return APIMainEnviroment(baseUrl: APIConfiguration.baseUrl,
                                 headers: APIConfiguration.httpHeaders,
                                 encoding: APIConfiguration.encoding,
                                 timeout: APIConfiguration.timeout)
    }
    
    class var defaultPOSTEnvironment: APIMainEnviroment {
        return APIMainEnviroment(baseUrl: APIConfiguration.baseUrl,
                                 headers: APIConfiguration.httpHeaders,
                                 encoding: JSONEncoding.default,
                                 timeout: APIConfiguration.timeout)
    }
    
    class var user: APIMainEnviroment {
        return APIMainEnviroment(baseUrl: APIConfiguration.baseUrl,
                                 headers: APIConfiguration.userHeaders,
                                 encoding: APIConfiguration.encoding,
                                 timeout: APIConfiguration.timeout)
    }
    
    class var userPost: APIMainEnviroment {
        return APIMainEnviroment(baseUrl: APIConfiguration.baseUrl,
                                 headers: APIConfiguration.userHeaders,
                                 encoding: JSONEncoding.default,
                                 timeout: APIConfiguration.timeout)
    }
    

    
    // MARK: - Init
    init(baseUrl: String, headers: HTTPHeaders, encoding: ParameterEncoding, timeout: TimeInterval) {
        self.baseUrl = baseUrl
        self.headers = headers
        self.encoding = encoding
        self.timeout = timeout
    }
    
    // MARK: - Builder
    @discardableResult
    func set(baseUrl: String) -> APIMainEnviroment {
        self.baseUrl = baseUrl
        return self
    }
    
    @discardableResult
    func set(headers: HTTPHeaders) -> APIMainEnviroment {
        self.headers = headers
        return self
    }
    
    @discardableResult
    func set(encoding: ParameterEncoding) -> APIMainEnviroment {
        self.encoding = encoding
        return self
    }
    
    @discardableResult
    func set(timeout: TimeInterval) -> APIMainEnviroment {
        self.timeout = timeout
        return self
    }
}



