//
//  LoginRequest.swift
//  Arum
//
//  Created by trinhhc on 5/25/21.
//

import UIKit

struct LoginRequest: BaseRequestModel {
    var mobile: String
    var name: String
    var is_auto_login: Bool
    var device_id: String
}
