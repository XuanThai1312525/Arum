//
//  DispatcherProtocol.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public protocol APIDispatcherProtocol {
    // Execute the request
    func execute(request: APIRequest, completed: ((_ json: APIResponse) -> Void)?)
    func prepareBodyFor(request: APIRequest) -> URLRequestConvertible
    func prepareRawFor(request: APIRequest, rawText: String) -> URLRequest?
    func prepareHeadersForMultipartOrBinary(request: APIRequest) -> HTTPHeaders
    func cancel()
}
