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
        setupCookies()
        setupAppEnvironment(application,launchOptions)
        navigator.startup(window)
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}

