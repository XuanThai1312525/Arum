//
//  APIService.swift
//  Arum
//
//  Created by trinhhc on 5/25/21.
//

import RxSwift
import Alamofire

class APIService {
    static func login(request: LoginRequest) -> Observable<LoginResponse> {
        return rxRequestlogin(name: "Login", request: request, path: Constants.APIPaths.authentication.login, method: .post)
    }
    static func sendOTPCode(request: SendOTPRequest) -> Observable<SendOTPResponse> {
        return rxRequestlogin(name: "Send OTP", request: request, path: Constants.APIPaths.authentication.sendOTPCode, method: .post)
    }
    
    static func verifyOTPCode(code_id: String,request: VerifyOTPRequest) -> Observable<SendOTPResponse> {
        return rxRequestlogin(name: "Verify OTP", request: request, path: String.init(format: Constants.APIPaths.authentication.verifyOTPCode, code_id), method: .post)
    }
    
    static func checkDeviceID(request: CheckingDeviceRequest) -> Observable<CheckingDeviceResponse> {
        return rxRequestlogin(name: "Check Device ID", request: request, path: Constants.APIPaths.authentication.checkDeviceID, method: .post)
    }
    
}

func rxRequestlogin<T:BaseResponseModel>(name: String = "",request: BaseRequestModel,path: String = "", method: HTTPMethod = .get) -> Observable<T> {
    return APIOperation<T>.init(request: APIRequest(name: name, path: path, method: method,parameters: APIParameterType.body(request.dictionary)))
        .rxExecute()
}
