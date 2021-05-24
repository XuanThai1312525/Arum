//
//  NetworkRequestManager.swift
//  Arum
//
//  Created by trinhhc on 5/25/21.
//

import RxSwift
import Alamofire

class NetworkRequestManager {
    static func login(request: LoginRequest) -> Observable<LoginResponse> {
        return rxRequestlogin(name: "Login", request: request, path: Constants.APIPaths.authentication.login, method: .post)
    }
}

func rxRequestlogin<T:BaseResponseModel>(name: String = "",request: BaseRequestModel,path: String = "", method: HTTPMethod = .get) -> Observable<T> {
    return APIOperation<T>.init(request: APIRequest(name: name, path: path, method: method,parameters: APIParameterType.body(request.dictionary)))
        .rxExecute()
}
