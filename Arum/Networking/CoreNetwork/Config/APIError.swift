//
//  ErrorExtension.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

public enum APIError: Error {
    case api(statusCode: Int?, apiCode: Int?, message: String?)
    case request(statusCode: Int?, error: Error?)
    
    var apiCode: Int? {
        switch self {
        case .api(_, let apiCode, _):
            return apiCode
        default:
            return nil
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .api(let statusCode, _, _):
            return statusCode
        case .request(let statusCode, _):
            return statusCode
        }
    }
    
    var message: String? {
        switch self {
        case .api(_, _, let message):
            return message
        case .request(_, let error):
            guard let error = error else {
                return "Lỗi không xác định"
            }
            if error.isInternetOffline || error.isNetworkConnectionLost || error.isHostConnectFailed {
                return "Không có kết nối Internet"
            } else if error.isTimeout {
                return "Quá thời gian kết nối tới máy chủ"
            } else if error.isBadServerResponse {
                return "Không có dữ liệu từ máy chủ"
            } else {
                return error.localizedDescription
            }
        }
    }
    
    // Create an unknown api error
    static var unknown: APIError {
        return APIError.request(statusCode: nil, error: nil)
    }
    
    static func parseAPIErrorFrom(json: JSON, statusCode: Int?) -> APIError? {
        let apiError = APIConfiguration.parseAPIErrorFrom(json, statusCode: statusCode)
        return apiError
    }
}
