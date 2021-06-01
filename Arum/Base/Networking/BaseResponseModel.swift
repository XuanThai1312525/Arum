//
//  BaseResponseModel.swift
//  Arum
//
//  Created by trinhhc on 5/25/21.
//

import SwiftyJSON

class BaseResponseModel: APIResponseProtocol {
    var msg: String
    var success: Bool
    required init(json: JSON) {
        self.msg = json["msg"].stringValue
        self.success = json["success"].boolValue
    }
    

}
