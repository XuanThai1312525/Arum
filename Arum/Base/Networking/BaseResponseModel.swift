//
//  BaseResponseModel.swift
//  Arum
//
//  Created by trinhhc on 5/25/21.
//

import SwiftyJSON

class BaseResponseModel: APIResponseProtocol {
    required init(json: JSON) {
        print(json)
    }
    

}
