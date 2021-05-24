//
//  UserSession.swift
//  Arum
//
//  Created by TRINH.HO2 on 16/05/2021.
//

import RxCocoa

class UserSession {
    public static let shared = UserSession()
    public let roleSubject = BehaviorRelay<RoleAccess>(value: .login)
    
    func getUserInfo() -> UserInfo? {
        guard let data = UserDefaults.standard.data(forKey: "USER_INFO_KEY") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let userInfo = try? decoder.decode(UserInfo.self, from: data)
        
        return userInfo
        
    }
    
    func saveUserInfo(_ userInfo: UserInfo) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(userInfo)
        UserDefaults.standard.setValue(data, forKey: Constants.USER_INFO_KEY)
        UserDefaults.standard.synchronize()
    }
}

struct UserInfo : Codable {
    var phoneNumber: String = ""
    var name: String = ""
    var deviceId: String = ""
}


enum RoleAccess {
    case logged
    case login
}
