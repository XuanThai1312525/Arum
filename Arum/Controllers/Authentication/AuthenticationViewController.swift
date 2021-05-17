//
//  AuthenticationViewController.swift
//  Arum
//
//  Created by TRINH.HO2 on 17/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

class AuthenticationViewController: BaseViewController {
    @IBOutlet weak var nameTextField: UnderLineTextField!
    @IBOutlet weak var phoneTextField: UnderLineTextField!
    @IBOutlet weak var otpTextField: UnderLineTextField!
    @IBOutlet weak var otpTimeOutLabel: UILabel!
    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        self.navigationBarWithBackTitle(title: "", backTitle: "본인인증절차" )
        
        
    }
    
    override func setupUI() {
        super.setupUI()
        
        sendOtpButton.layer.cornerRadius = sendOtpButton.frame.height/2
        confirmButton.layer.cornerRadius = confirmButton.frame.height/2
        
        otpTimeOutLabel.font = UIFont.appleGothic.regular.font(size: 14)
        
        nameTextField.isPlaceHolderAnimation = false
        nameTextField.isBottomLine = true
        
        phoneTextField.isPlaceHolderAnimation = false
        phoneTextField.isBottomLine = true
        
        otpTextField.isPlaceHolderAnimation = false
        otpTextField.isBottomLine = true
        
        self.view.layoutIfNeeded()
        
    }
    
    

}
