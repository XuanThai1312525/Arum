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
}


enum RoleAccess {
    case logged
    case login
}
