//
//  EnumType.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation


enum ValidatePasswordError: Int {
    case captitalLetterError = 0
    case smallLetterError
    case numericError
    case PassowrdLengthError
    case EmptyPasswordError
    case ValidPassword
    
    var errorMsg: String {
        switch self {
        case .captitalLetterError:
            return "common.password.must.contain.uppercase.letters".localized
        case .smallLetterError:
            return "common.password.must.contain.lowercase.letters".localized
        case .numericError:
            return "common.password.must.contain.number".localized
        case .EmptyPasswordError:
            return "common.password.empty".localized
        case .PassowrdLengthError:
            return "common.password.has.over.8.character".localized
        default:
            return "".localized
        }
    }
}
