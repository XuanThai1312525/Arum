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
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UnderLineTextField!
    @IBOutlet weak var phoneTextField: UnderLineTextField!
    @IBOutlet weak var otpTextField: UnderLineTextField!
    @IBOutlet weak var otpTimeOutLabel: UILabel!
    @IBOutlet weak var sendOtpButton: UIButton!
    @IBOutlet weak var verifyOtpButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: Properties
    let viewModel = AuthenticationViewModel()
    
    
    //MARK: Lifecycle
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
        verifyOtpButton.layer.cornerRadius = verifyOtpButton.frame.height/2
        
        otpTimeOutLabel.font = UIFont.appleGothic.regular.font(size: 14)
        
        nameTextField.isPlaceHolderAnimation = false
        nameTextField.isBottomLine = true
        nameTextField.validationType = .afterEdit
        
        phoneTextField.isPlaceHolderAnimation = false
        phoneTextField.isBottomLine = true
        phoneTextField.validationType = .afterEdit
        
        otpTextField.isPlaceHolderAnimation = false
        otpTextField.isBottomLine = true
        otpTextField.validationType = .afterEdit
        
        setEnableConfirmButton(false)
        
    }
    
    override func setupTap() {
        super.setupTap()
        
        self.cancelButton
            .rx
            .tap
            .subscribe { (event) in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.confirmButton
            .rx
            .tap
            .subscribe {[weak self] (event) in
                guard let _self = self else {return}
                print("Go To main Screen")
                _self.loadWebview(urlString: Constants.BASE_URL)
            }
            .disposed(by: disposeBag)
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        let output = viewModel.transform(input: AuthenticationViewModel.Input(nameTrigger: nameTextField.rx.text.orEmpty.asObservable(), phoneTrigger: phoneTextField.rx.text.orEmpty.asObservable(),otpTrigger: otpTextField.rx.text.orEmpty.asObservable(), sendOtpTrigger: sendOtpButton.rx.tap.asObservable(),verifyOtpTrigger: verifyOtpButton.rx.tap.asObservable(), confirmTrigger: confirmButton.rx.tap.asObservable()))
        output.nameValidateResult
            .bind(to: nameTextField.errorBinding)
            .disposed(by: disposeBag)
        
        output.phoneValidateResult
            .bind(to: phoneTextField.errorBinding)
            .disposed(by: disposeBag)
        
        output.otpValidateResult
            .bind(to: otpTextField.errorBinding)
            .disposed(by: disposeBag)
        
        
        output.sendOtpSuccess
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { [weak self](valid) in
                guard let self = self else {
                    return
                }
                
                self.otpTimeOutLabel.isHidden = false
                self.sendOtpButton.isEnabled = false
                self.verifyOtpButton.isEnabled = true
                self.setEnableConfirmButton(false)
                
                let time = 60*3
                Observable<Int>
                    .timer(0, period: 1, scheduler: MainScheduler.instance)
                    .take(time)
                    .map { time - $0 }
                    .subscribe(onNext: { [weak self](timePassed) in
                        let seconds = timePassed % 60
                        let minutes = (timePassed / 60) % 60
                        
                        self?.otpTimeOutLabel.text = String(format: "%0.2d:%0.2d",minutes,seconds)
                    },onCompleted: {
                        self.otpTimeOutLabel.isHidden = true
                        self.sendOtpButton.isEnabled = true
                        self.verifyOtpButton.isEnabled = false
                        self.otpTextField.text = ""
                    })
                    .disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
        
        
        output.verifyOtpSuccess
            .do { [weak self](valid) in
                guard let self = self else {
                    return
                }
                self.setEnableConfirmButton(true)
            }
            .bind(to: alertBinding)
            .disposed(by: disposeBag)
        
        output.onError
            .bind(to: errorBinding)
            .disposed(by: disposeBag)
        
        output.activityIndicator
            .bind(to: activityIndicatorEntireScreenBinder)
            .disposed(by: disposeBag)
        
        output.authenticationSuccess
            .bind { [weak self](_) in
                if let vc = self?.navigationController?.viewControllers.last(where: {$0.isKind(of: ARWebContentViewController.self)}) as? ARWebContentViewController {
                    vc.urlString = Constants.BASE_URL
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.pop(to: vc)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }

    
    func setEnableConfirmButton(_ isEnable: Bool) {
        if (isEnable) {
            self.confirmButton.isEnabled = true
            self.confirmButton.backgroundColor = #colorLiteral(red: 0.3019607843, green: 0.7411764706, blue: 0.5803921569, alpha: 1)
            self.confirmButton.setTitleColor(UIColor.white, for: .normal)
            self.confirmButton.borderWidth = 0
        } else {
            self.confirmButton.isEnabled = false
            self.confirmButton.backgroundColor = UIColor.white
            self.confirmButton.borderWidth = 1
            self.confirmButton.setTitleColor( #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1) , for: .normal)
        }
    }
}
