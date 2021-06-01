//
//  SendOTPResponse.swift
//  Arum
//
//  Created by trinhhc on 5/26/21.
//

import SwiftyJSON

class SendOTPResponse: BaseResponseModel {
    var code_id: String
    required init(json: JSON) {
        self.code_id = json["code_id"].stringValue
        super.init(json: json)
    }
}
