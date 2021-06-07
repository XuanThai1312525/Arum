//
//  SignInViewController.swift
//  LANE4
//
//  Created by Admim on 12/7/20.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import RxCocoa
import RxSwift
import CoreLocation

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
    let locationManager = CLLocationManager()
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        
        nameUnderLineTextField.isPlaceHolderAnimation = false
        nameUnderLineTextField.isBottomLine = true
        nameUnderLineTextField.validationType = .afterEdit
        
        phoneNumberUnderLineTextField.isPlaceHolderAnimation = false
        phoneNumberUnderLineTextField.isBottomLine = true
        phoneNumberUnderLineTextField.validationType = .afterEdit
        
        locationManager.requestAlwaysAuthorization()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(UserSession.roleSubject.value == .logged) {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
    }
    
    override func setupTap() {
        super.setupTap()
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        let loginNormalTrigger = loginButton.rx.tap.mapToVoid()
        
        let isAutoLoginTrigger = automaticLoginButton.rx.tap
            .map{self.automaticLoginButton.isSelected}
        
        let snsTrigger = Observable.merge([
            fbLoginButton.rx.tap.map{SNSType.fb},
            appleLoginButton.rx.tap.map{SNSType.apple},
            kakaoLoginButton.rx.tap.map{SNSType.kakao},
            naverLoginButton.rx.tap.map{SNSType.naver}
        ])
        
        
        let input = SignInViewModel.Input(loginWithSNSTrigger: snsTrigger, loginNormalTrigger: loginNormalTrigger, signUpTrigger: signUpButton.rx.tap.asObservable(),nameTrigger: nameUnderLineTextField.rx.text.orEmpty.asObservable(),phoneTrigger: phoneNumberUnderLineTextField.rx.text.orEmpty.asObservable(),isAutoLogin: isAutoLoginTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.activityIndicator
            .bind(to: activityIndicatorEntireScreenBinder)
            .disposed(by: disposeBag)
        
        output.logInSNS
            .subscribe(onNext: { [weak self](url) in
                self?.gotoLoginSNS(url: url)
            })
            .disposed(by: disposeBag)
        
        output.onNeedAuthentication
            .subscribe(onNext: { [weak self](_) in
                print("Login Success")
                self?.phoneNumberUnderLineTextField.resetState()
                self?.gotoAuthentication()
            })
            .disposed(by: disposeBag)
        
        output.onNeedPopBackToMain
            .subscribe(onNext: { [weak self](url) in
                self?.goBackToLogin(url: url)
            })
            .disposed(by: disposeBag)
        
        output.nameValidateResult
            .bind(to: nameUnderLineTextField.errorBinding)
            .disposed(by: disposeBag)
        
        output.phoneValidateResult
            .bind(to: phoneNumberUnderLineTextField.errorBinding)
            .disposed(by: disposeBag)
        
        output.isAutoLoginValidResult
            .bind(to: automaticLoginButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.onError
            .subscribe(onNext: { [weak self](url) in
                self?.phoneNumberUnderLineTextField.forceError(errorText: "로그인 정보가 정확하지 않습니다.")
            })
            .disposed(by: disposeBag)
        output.onSignUp
            .subscribe(onNext: { [weak self](url) in
                self?.gotoSignUp(url: url)
            })
            .disposed(by: disposeBag)
    }
    
}

//MARK: Navigation
extension SignInViewController {
    func gotoLoginSNS(url: String) {
        navigator.loadWebview(urlString: url, context: NavigationContext().fromVC(self))
    }
    
    func gotoSignUp(url: String) {
        navigator.loadWebview(urlString: url, context: NavigationContext().fromVC(self))
    }
    
    func goBackToLogin(url: String) {
        navigator.loadWebview(urlString: url, context: NavigationContext().fromVC(self))
    }
    
    func gotoAuthentication() {
        let vc = AuthenticationViewController(nib: R.nib.authenticationViewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

