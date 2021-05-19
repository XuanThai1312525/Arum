//
//  Constants.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
import UIKit

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
            return ""
        default:
            return "https://aleum.kr"
        }
    }
    
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
    enum Kakao {
        static let KAKAO_NATIVE_APP_KEY = "3e8d672c34ffeef7293e13f755b42be6"
    }
    
    enum Naver {
        static let URL_SCHEMA = "com.arumInc.app.naver" //URL Scheme entered when registering the application This is the URL Scheme to receive a callback after the OAuth 2.0 login process is completed.
        static let CONSUMER_KEY = "3vgVAF53f1VomT7tFho1" //    Client ID issued after application registration
        static let CONSUMER_SECRET = "ajpamZwLiM" //Client secret issued after application registration
        static let SERVICE_NAME = "Arum" //Client secret issued after application registration
    }
}
