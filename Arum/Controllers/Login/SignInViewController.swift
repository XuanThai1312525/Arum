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
    @IBOutlet weak var nameUnderLineTextField: UnderLineTextField!
    @IBOutlet weak var phoneNumberUnderLineTextField: UnderLineTextField!
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var naverLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var automaticLoginButton: UIButton!
    
    //MARK: Properties
    let viewModel = SignInViewModel()
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func setupUI() {
        
        nameUnderLineTextField.isPlaceHolderAnimation = false
        nameUnderLineTextField.isBottomLine = true
        nameUnderLineTextField.validationType = .onFly
        nameUnderLineTextField.errorText = "잘못된 이름"
        nameUnderLineTextField.onValidate = { text in
            return !text.isEmpty
        }
        
        phoneNumberUnderLineTextField.isPlaceHolderAnimation = false
        phoneNumberUnderLineTextField.isBottomLine = true
        phoneNumberUnderLineTextField.validationType = .onFly
        phoneNumberUnderLineTextField.errorText = "유효하지 않은 전화 번호"
        phoneNumberUnderLineTextField.onValidate = { text in
            return text.isPhoneNumber
        }
        
        //Fake data
        nameUnderLineTextField.text = "목회자"
        phoneNumberUnderLineTextField.text = "01040862424"
        
    }
    
    override func setupTap() {
        super.setupTap()
        automaticLoginButton.rx
            .tap
            .bind { [unowned self]() in
                self.automaticLoginButton.isSelected = !self.automaticLoginButton.isSelected
            }.disposed(by: disposeBag)
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        let snsTrigger = PublishSubject<SNSType>()
        let loginNormalTrigger = loginButton.rx.tap.map{LoginRequest(mobile: self.phoneNumberUnderLineTextField.text.emptyOnNil , name: self.nameUnderLineTextField.text.emptyOnNil, is_auto_login: self.automaticLoginButton.isSelected, device_id: UUID().uuidString)}
        fbLoginButton.rx
            .tap
            .map{SNSType.fb}
            .bind(to: snsTrigger)
            .disposed(by: disposeBag)
        
        
        let input = SignInViewModel.Input(loginWithSNSTrigger: snsTrigger, loginNormalTrigger: loginNormalTrigger)
        let output = viewModel.transform(input: input)
        
        output.activityIndicator
            .bind(to: activityIndicatorEntireScreenBinder)
            .disposed(by: disposeBag)
        
        output.logInSNS
            .subscribe(onNext: { [weak self](url) in
                self?.gotoLoginSNS(url: url)
            })
            .disposed(by: disposeBag)
        
        output.loginSuccess
            .subscribe(onNext: { [weak self](url) in
                print("Login Success")
                self?.gotoAuthentication()
            })
            .disposed(by: disposeBag)
        
        output.onError
            .subscribe(onNext: { [weak self](url) in
                self?.phoneNumberUnderLineTextField.forceError(errorText: "로그인 정보가 정확하지 않습니다.")
            })
            .disposed(by: disposeBag)
        
    }
    
}

//MARK: Navigation
extension SignInViewController {
    func gotoLoginSNS(url: String) {
        let vc = SignInSNSViewController(nib: R.nib.signInSNSViewController)
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoAuthentication() {
        let vc = AuthenticationViewController(nib: R.nib.authenticationViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


