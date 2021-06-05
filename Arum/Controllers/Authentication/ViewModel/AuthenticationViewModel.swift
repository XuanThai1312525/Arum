//
//  AuthenticationViewModel.swift
//  Arum
//
//  Created by trinhhc on 5/25/21.
//

import RxSwift

class AuthenticationViewModel: BaseViewModel {
    struct Input {
        var nameTrigger: Observable<String>
        var phoneTrigger: Observable<String>
        var otpTrigger: Observable<String>
        var sendOtpTrigger: Observable<Void>
        var verifyOtpTrigger: Observable<Void>
        var confirmTrigger: Observable<Void>
    }
    
    struct Output {
        var activityIndicator: Observable<Bool>
        var nameValidateResult: Observable<ValidateResult>
        var phoneValidateResult: Observable<ValidateResult>
        var otpValidateResult: Observable<ValidateResult>
        var onError: Observable<Error>
        var sendOtpSuccess: Observable<Bool>
        var verifyOtpSuccess: Observable<String>
        var authenticationSuccess: Observable<Void>
    }
    func transform(input: Input) -> Output {
        
        let nameValidateResult =  BehaviorSubject<ValidateResult>(value: ValidateResult(isValid: false, errorMessage: "이름을 입력해 주세요."))
        let phoneValidateResult =  BehaviorSubject<ValidateResult>(value: ValidateResult(isValid: false, errorMessage: "휴대폰번호를 입력해주세요."))
        let otpValidateResult =  BehaviorSubject<ValidateResult>(value: ValidateResult(isValid: false, errorMessage: "인증번호를 입력해 주세요."))
        
        input.nameTrigger
            .distinctUntilChanged()
            .map{ValidateResult(isValid: !$0.isEmpty, errorMessage: "이름을 입력해 주세요.")}
            .bind(to: nameValidateResult)
            .disposed(by: disposeBag)
        
        input.phoneTrigger
            .distinctUntilChanged()
            .map{ValidateResult(isValid: $0.isPhoneNumber, errorMessage: "휴대폰번호를 입력해주세요.")}
            .bind(to: phoneValidateResult)
            .disposed(by: disposeBag)
        
        input.otpTrigger
            .distinctUntilChanged()
            .map{ValidateResult(isValid: !$0.isEmpty, errorMessage: "인증번호를 입력해 주세요.")}
            .bind(to: otpValidateResult)
            .disposed(by: disposeBag)
        
        let isValid = Observable.combineLatest(nameValidateResult, phoneValidateResult).map{$0.isValid && $1.isValid}
        
        let requestOtpInfo = Observable.combineLatest(input.nameTrigger,input.phoneTrigger).map{SendOTPRequest(target: $1)}
        
        let sendOtpTrigger = input.sendOtpTrigger.withLatestFrom(isValid)
        
        sendOtpTrigger.filter{!$0}
            .subscribe { (valid) in
                nameValidateResult.onNext(try! nameValidateResult.value())
                phoneValidateResult.onNext(try! phoneValidateResult.value())
            }.disposed(by: disposeBag)
        let sendOtpResult = sendOtpTrigger
            .filter{$0}
            .mapToVoid()
            .withLatestFrom(requestOtpInfo)
            .flatMapLatest {(info) in
                return APIService.sendOTPCode(request: info)
                .trackActivity(self._activityIndicator)
                .trackError(self._errorTracker)
            }
            .do(onNext: { [weak self](response) in
                guard let self = self else {
                    return
                }
                if !response.success {
                    self._errorTracker.onError(NSError.getError(message: response.msg))
                }
            })
            .filter{$0.success}
            .share()
        
        let verifyOtpInfo = Observable.combineLatest(sendOtpResult,input.otpTrigger).map{($0.0.code_id,VerifyOTPRequest.init(code: $0.1))}
        
        
        let verifyOtpSuccess = input.verifyOtpTrigger
            .withLatestFrom(verifyOtpInfo)
            .flatMapLatest {(info) in
                return APIService.verifyOTPCode(code_id: info.0, request:info.1)
                .trackActivity(self._activityIndicator)
                .trackError(self._errorTracker)
            }
            .do(onNext: { [weak self](response) in
                guard let self = self else {
                    return
                }
                if !response.success {
                    self._errorTracker.onError(NSError.getError(message:"인증 코드 다시 확인해주세요"))
                }
            })
            .filter{$0.success}
            .map{_ in "인증 완료되었습니다"}
            .share()
        
        let authenticationSuccess = input.confirmTrigger.withLatestFrom(verifyOtpSuccess).mapToVoid()
        
        
        return Output(activityIndicator: activityIndicator,nameValidateResult: nameValidateResult.skip(1),phoneValidateResult: phoneValidateResult.skip(1), otpValidateResult: otpValidateResult.skip(1),onError: errorTracker, sendOtpSuccess: sendOtpResult.map{_ in true}, verifyOtpSuccess:  verifyOtpSuccess, authenticationSuccess: authenticationSuccess)
        
    }
}
