//
//  SignInViewController.swift
//  LANE4
//
//  Created by Admim on 12/7/20.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import RxCocoa
import RxSwift

class SignInViewController: HideNavigationBarViewController {
    //MARK: Outlets
    @IBOutlet weak var loginButton: AppButton!
    @IBOutlet weak var signUpButton: AppButton!
    @IBOutlet weak var emailUnderLineTextField: UnderLineTextField!
    @IBOutlet weak var passwordUnderLineTextField: UnderLineTextField!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var naverLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    //MARK: Properties
    let viewModel = SignInViewModel()
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func setupUI() {
        
        emailUnderLineTextField.isPlaceHolderAnimation = false
        emailUnderLineTextField.isBottomLine = true
        
        passwordUnderLineTextField.isPlaceHolderAnimation = false
        passwordUnderLineTextField.isBottomLine = true
        
    }
    
    override func setupTap() {
        super.setupTap()
        
        loginButton.rx.tap.subscribe { (_) in
            self.navigationController?.pushViewController( AuthenticationViewController(nib: R.nib.authenticationViewController), animated: true)
        }.disposed(by: disposeBag)
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
    }
    
}


