//
//  AppDelegate.swift
//  Arum
//
//  Created by Admim on 5/15/21.
//

import RxSwift
import RxCocoa


@main
class AppDelegate: UIResponder, UIApplicationDelegate, HasAppProperties {

    static let shared = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow!
    let bag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupAppEnvironment(application,launchOptions)
        navigator.startup(window)
        return true
    }
}

