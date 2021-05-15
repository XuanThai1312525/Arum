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
