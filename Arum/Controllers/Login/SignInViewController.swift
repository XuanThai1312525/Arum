//
//  SignInViewController.swift
//  LANE4
//
//  Created by Admim on 12/7/20.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import UIKit

class SignInViewController: HideNavigationBarViewController {
    @IBOutlet weak var loginButton: AppButton!
    @IBOutlet weak var signUpButton: AppButton!
    @IBOutlet weak var emailUnderLineTextField: UnderLineTextField!
    @IBOutlet weak var passwordUnderLineTextField: UnderLineTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configs()
    }
    
    private func configs() {
        
        emailUnderLineTextField.isPlaceHolderAnimation = false
        emailUnderLineTextField.isBottomLine = true
        
        passwordUnderLineTextField.isPlaceHolderAnimation = false
        passwordUnderLineTextField.isBottomLine = true
//        passwordUnderLineTextField.font = 
        
//        let emailAppearance = TextInputViewAppear(descriptionText: "메일주소를 입력해 주세요.".localizedCapitalized, validText: nil, isShowValidText: true, invalidText: "메일주소를 입력해", invalidColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), validColor: #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1))
//        emailInputView.appearance(emailAppearance)
//        
//        let passwordAppearance = TextInputViewAppear(descriptionText: "비밀번호를 입력해 주세요.".localizedCapitalized, validText:nil,  isShowValidText: true, invalidText: "메일주소를 입력해", invalidColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), validColor: #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1))
//        passwordInputView.appearance(passwordAppearance)
//        
//        emailInputView.bindingUI(isValid: false)
//        passwordInputView.bindingUI(isValid: false)

    }
    
    override func setupTap() {
        super.setupTap()
        
        loginButton.rx.tap.subscribe { (_) in
            self.navigationController?.pushViewController( AuthenticationViewController(nib: R.nib.authenticationViewController), animated: true)
        }.disposed(by: disposeBag)
        
    }
    
}
