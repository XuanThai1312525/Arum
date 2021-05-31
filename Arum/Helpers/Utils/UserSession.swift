//
//  UserSession.swift
//  Arum
//
//  Created by TRINH.HO2 on 16/05/2021.
//

import RxCocoa

class UserSession {
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
    
    static func setSessionCookie () {
        if let url = URL.init(string: Constants.BASE_URL + "/" + Constants.APIPaths.authentication.login),
           let cookies = HTTPCookieStorage.shared.cookies(for: url),
           let loginCookie = cookies.first(where: {$0.name.elementsEqual("aleum_session")})
        {
                UserDefaults.standard.set(loginCookie.properties, forKey: "kCookie")
                UserDefaults.standard.synchronize()
        }
        
    }
    
    static func getSessionCookie () -> HTTPCookie?
    {
        guard let properties = UserDefaults.standard.object(forKey: "kCookie") as? [HTTPCookiePropertyKey : Any] else {
            return nil
        }
        let cookie = HTTPCookie(properties: properties)
        return cookie
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
    case needAuthentication
    case needToCheckDeviceID
    case login
    
    static func role(userInfo: UserInfo?) -> RoleAccess {
        guard let userInfo = userInfo else {
            return .login
        }
        
        guard !userInfo.deviceId.isEmpty else {
            return .login
        }
        
        guard userInfo.isAutomaticLogin else {
            return .login
        }
        return  .needToCheckDeviceID
    }
}
