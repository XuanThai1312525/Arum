//
//  LoginResponse.swift
//  Arum
//
//  Created by trinhhc on 5/24/21.
//

import UIKit
import SwiftyJSON

class LoginResponse: BaseResponseModel {
    var msg: String
    var success: Bool
    required init(json: JSON) {
        self.msg = json["msg"].stringValue
        self.success = json["success"].boolValue
        super.init(json: json)
    }
    

}
