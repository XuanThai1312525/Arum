//
//  CheckingDeviceResponse.swift
//  Arum
//
//  Created by trinhhc on 5/26/21.
//

import SwiftyJSON

class CheckingDeviceResponse: BaseResponseModel {
    var code: String
    required init(json: JSON) {
        self.code = json["code"].stringValue
        super.init(json: json)
    }
}
