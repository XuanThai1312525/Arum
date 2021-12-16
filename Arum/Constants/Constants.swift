//
//  Constants.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Constants {
    enum Enviroment {
        case develop, production
    }
    
    static var enviroment: Enviroment {
        return .production
    }

}

extension Constants {
    static var BASE_URL: String {
        switch Constants.enviroment {
        case .develop:
            return "https://aleum.kr"
        default:
            return "https://aleum.kr"
        }
    }
    
    static var SIGN_UP_URL = BASE_URL+"/join/home"
    
    //MARK: -  URL Login Modules
    struct LoginModule {
        static let login = ""
        
    }
}

extension Constants {
    static func fontDefault(size: CGFloat) ->UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    static func fontBold(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
}

//MARK: Authentication
extension Constants {
    enum SNS_URL {
        static let KAKAO = "https://aleum.kr/login-sns/kakao"
        static let FB = "https://aleum.kr/login-sns/facebook"
        static let APPLE = "https://aleum.kr/login-sns/apple"
        static let NAVER = "https://aleum.kr/login-sns/naver"
    }
}

//MARK: API PATHS
extension Constants {
    enum APIPaths {
        enum authentication {
            static let login = "api/users/login"
            static let sendOTPCode = "api/verification-codes"
            static let verifyOTPCode = "api/verification-codes/%@/check-code"
            static let checkDeviceID = "api/device"
        }
    }
}

//MARK: User Info
extension Constants {
    static let USER_INFO_KEY = "USER_INFO_KEY"
    static let rewardAd = "ca-app-pub-3305422501449778/6979782299"
    static let fullScreenAd = "ca-app-pub-3305422501449778/1919027303"
}
