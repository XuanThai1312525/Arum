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
            .subscribe { (event) in
                print("Go To main Screen")
                
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
                self.confirmButton.isEnabled = false
                
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
                self.confirmButton.isEnabled = true
            }
            .bind(to: alertBinding)
            .disposed(by: disposeBag)
        
        output.onError
            .bind(to: errorBinding)
            .disposed(by: disposeBag)
        
        output.activityIndicator
            .bind(to: activityIndicatorEntireScreenBinder)
            .disposed(by: disposeBag)
        
    }

}
