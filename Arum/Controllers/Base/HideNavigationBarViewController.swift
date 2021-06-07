//
//  HideNavigationBarViewController.swift
//  Arum
//
//  Created by TRINH.HO2 on 16/05/2021.
//

import UIKit

class HideNavigationBarViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        hideNavigationBar()
    }
    
}
