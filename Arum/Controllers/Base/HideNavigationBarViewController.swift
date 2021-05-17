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
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.navigationBar.barTintColor =  UIColor(white: 1, alpha: 0)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor(white: 1, alpha: 0)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    

}
