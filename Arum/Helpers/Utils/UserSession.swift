//
//  UserSession.swift
//  Arum
//
//  Created by TRINH.HO2 on 16/05/2021.
//

import RxCocoa

class UserSession {
    static var UUID_TOKEN: String?
    static let roleSubject = BehaviorRelay<RoleAccess>(value: RoleAccess.role(userInfo: userInfo) )
    static var userInfo = getUserInfo()
    
    private static func getUserInfo() -> UserInfo? {
        guard let data = UserDefaults.standard.data(forKey: "USER_INFO_KEY") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let userInfo = try? decoder.decode(UserInfo.self, from: data)
        
        return userInfo
        
    }
    
    static func saveUserInfo(_ userInfo: UserInfo) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(userInfo)
        UserDefaults.standard.setValue(data, forKey: Constants.USER_INFO_KEY)
        UserDefaults.standard.synchronize()
        
        self.userInfo = userInfo
    }
}

struct UserInfo : Codable {
    var phoneNumber: String = ""
    var name: String = ""
    var deviceId: String = ""
    var isAutomaticLogin: Bool = false
}


enum RoleAccess {
    case logged
    case needLoginOnly
    case needToCheckDeviceID
    case needLoginAndAuthen
    
    static func role(userInfo: UserInfo?) -> RoleAccess {
        guard let userInfo = userInfo else {
            return .needLoginAndAuthen
        }
        
        guard !userInfo.deviceId.isEmpty else {
            return .needLoginAndAuthen
        }
        
        guard userInfo.isAutomaticLogin else {
            return .needLoginOnly
        }
        return  .needToCheckDeviceID
    }
}
