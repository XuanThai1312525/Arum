//
//  SplashViewController.swift
//  Arum
//
//  Created by Admim on 7/6/21.
//

import UIKit

class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) {[weak self] timer in
            self?.navigator.handleSession()
        }
    }
}
