//
//  APIRequest.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public enum APIParameterType {
    case body(_ parameters: Parameters)
    case raw(_ text: String)
    case multipart(data: Data?, parameters: Parameters, name: String, fileName: String, mimeType: String)
    case binary(_ data: Data)
}

// Request
public struct APIRequest {
    var enviroment: APIMainEnviroment
    var name: String
    var path: String
    var method: HTTPMethod
    var expandedHeaders: HTTPHeaders
    var parameters: APIParameterType
    
    var asFullUrl: String {
        return enviroment.baseUrl + (!path.isEmpty ? "/" : "") + path
    }
    
    var asFullHttpHeaders: HTTPHeaders {
        var fullHeaders: HTTPHeaders = [:]
        enviroment.headers.forEach {
            fullHeaders[$0.name] = $0.value
        }
        expandedHeaders.forEach {
            fullHeaders[$0.name] = $0.value
        }
        return fullHeaders
    }
    
    init(name: String,
         path: String,
         method: HTTPMethod,
         expandedHeaders: HTTPHeaders = [:],
         parameters: APIParameterType = .body([:]),
         enviroment: APIMainEnviroment = .user) {
        self.name = name
        self.path = path
        self.method = method
        self.expandedHeaders = expandedHeaders
        self.parameters = parameters
        self.enviroment = enviroment
    }
    
    func printInformation() {
        print("\n[Request API] ▶︎ [\(name)]")
        print("▶︎ Full url: \(asFullUrl)")
        print("▶︎ Method: \(method.rawValue)")
        print("▶︎ HTTP Headers:\n\(asFullHttpHeaders)")
        switch parameters {
        case .body(let params):
            print("▶︎ Parameters:\n\(JSON(params))")
        case .raw(let text):
            print("▶︎ Raw text:\n\(text)")
        case .multipart(let data, let params, let name, let filename,let mimeType):
            print("▶︎ Data length: \(data?.count ?? 0)\n")
            print("▶︎ Name: \(name)\n")
            print("▶︎ Filename: \(filename)\n")
            print("▶︎ MimeType: \(mimeType)\n")
            print("▶︎ Parameters:\n\(JSON(params))")
        case .binary(let data):
            print("▶︎ Data length: \(data.count)\n")
        }
    }
}
