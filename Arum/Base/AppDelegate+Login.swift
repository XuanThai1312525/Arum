//
//  AppDelegate+Extension.swift
//  Arum
//
//  Created by TRINH.HO2 on 16/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

protocol HasAppProperties {
    var navigator: ArumAppNavigator {get}
}

extension HasAppProperties {
    var navigator: ArumAppNavigator {
        return ArumAppNavigator.shared
    }
}

//MARK: Authentication Session

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return false
    }
    
}
