//
//  SignInViewController.swift
//  LANE4
//
//  Created by Admim on 12/7/20.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailInputView: TextInputView!
    @IBOutlet weak var passwordInputView: TextInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configs()
    }
    
    private func configs() {
        loginButton.round(20)
        signUpButton.round(20)
        
        let emailAppearance = TextInputViewAppear(descriptionText: "메일주소를 입력해 주세요.".localizedCapitalized, validText: nil, isShowValidText: false, invalidText: nil, invalidColor: #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1), validColor: #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1))
        emailInputView.appearance(emailAppearance)
        
        let passwordAppearance = TextInputViewAppear(descriptionText: "비밀번호를 입력해 주세요.".localizedCapitalized, validText:nil, isShowValidText: true, invalidText: nil, invalidColor: #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1), validColor: #colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1))
        passwordInputView.appearance(passwordAppearance)

    }
}
