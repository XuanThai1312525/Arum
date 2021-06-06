//
//  LoadingViewModel.swift
//  Arum
//
//  Created by trinhhc on 5/27/21.
//

import RxSwift

class LoadingViewModel: BaseViewModel {
    struct Input {
        var checkDeviceTrigger: Observable<Void>
    }
    
    struct Output {
        var activityIndicator: Observable<Bool>
        var errorTracking: Observable<Error>
        var checkingSuccess: Observable<Void>
    }
    func transform(input: Input) -> Output {
        
        let checkingSuccess = input.checkDeviceTrigger
            .flatMapLatest {(info) in
                return APIService.checkDeviceID(request: CheckingDeviceRequest(device_id: (UserSession.userInfo?.deviceId).emptyOnNil))
                    .trackActivity(self._activityIndicator)
                    .trackError(self._errorTracker)
            }
            .do(onNext: { (response) in
                let code = response.code.uppercased()
                if code.elementsEqual("R000") {
                    UserSession.roleSubject.accept(.logged)
                } else if code.elementsEqual("R001") {
                    UserSession.roleSubject.accept(.needLoginOnly)
                } else {
                    UserSession.roleSubject.accept(.needLoginAndAuthen)
                }
            })
            .mapToVoid()

        let errorTracking = errorTracker
            .do { (error) in
                UserSession.roleSubject.accept(.needLoginAndAuthen)
            }
        
        return Output(activityIndicator: activityIndicator,errorTracking: errorTracking, checkingSuccess: checkingSuccess)
    }
    
}
