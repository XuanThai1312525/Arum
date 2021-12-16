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
import WebKit
import GoogleMobileAds

class SignInViewController: HideNavigationBarViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    private var privateWebview: WKWebView!
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
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let config = WKWebViewConfiguration()
//        config.preferences = preferences
        privateWebview = WKWebView(frame: .zero, configuration: config)
//        privateWebview.uiDelegate = self
        view.addSubview(privateWebview)
        privateWebview.fullscreen()
        privateWebview.scrollView.showsVerticalScrollIndicator = false
        privateWebview.scrollView.contentInsetAdjustmentBehavior = .never
        privateWebview.scrollView.bounces = false
//        privateWebview.navigationDelegate = self
        privateWebview.allowsLinkPreview = false
        privateWebview.backgroundColor = .clear
        privateWebview.navigationDelegate = self
//        view.sendSubviewToBack(privateWebview)
        privateWebview.isHidden = true
        privateWebview.backgroundColor = .clear
        privateWebview.isOpaque = false
        privateWebview.uiDelegate = self
        appleLoginButton.did(.touchUpInside) {[unowned self] (_, _) in
            guard let url = URL(string: Constants.SNS_URL.APPLE) else {return}
            
            let request = URLRequest(url: url)
            self.privateWebview.load(request)
//            self.view.bringSubviewToFront(self.privateWebview)
            self.privateWebview.isHidden = false
        }
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
//            appleLoginButton.rx.tap.map{SNSType.apple},
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
//                self?.loadAdmob()
            })
            .disposed(by: disposeBag)
    }
    
    
 
}

extension SignInViewController: WKNavigationDelegate,  WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
 
        guard let urlString = webView.url?.absoluteString else {
            decisionHandler(.cancel)
            return
        }
        if urlString.contains("apple.com/auth/authorize") || urlString.contains("aleum.kr/login-sns/apple")  {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)

        let dataStore = webView.configuration.websiteDataStore
        let cookieStore = dataStore.httpCookieStore
        cookieStore.getAllCookies { (cookies) in
            self.privateWebview.isHidden = true
            self.navigator.loadWebview(urlString: urlString, cookies: cookies, context: NavigationContext().fromVC(self))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.privateWebview.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        let title = NSLocalizedString("확인", comment: "확인")
//        let ok = UIAlertAction(title: title, style: .default) { (_: UIAlertAction) -> Void in
//            // alert.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(ok)
//        present(alert, animated: true)
        completionHandler()
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

