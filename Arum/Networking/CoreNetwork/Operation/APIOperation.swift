//
//  OperationTask.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 12/7/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift

class APIOperation<T: APIResponseProtocol>: APIOperationProtocol {

    // MARK: - Typealias
    typealias Output = T
    typealias DataResponseSuccess = (_ result: Output) -> Void
    typealias DataResponseError = (_ error: APIError) -> Void
    typealias ErrorDialogResponse = (() -> Void)
    typealias OfflineDialogResponse = ((_ tapRetry: Bool) -> Void)
    
    // MARK: - Constants
    struct TaskData {
        var responseQueue: DispatchQueue = .main
        var showIndicator: Bool = true
        var autoShowApiErrorAlert = true
        var autoShowRequestErrorAlert = true
        var didCloseApiErrorDialogHandler: ErrorDialogResponse? = nil
        var didCloseRequestErrorDialogHandler: ErrorDialogResponse? = nil
        var didCloseOfflineDialogHandler: OfflineDialogResponse? = nil
        var successHandler: DataResponseSuccess? = nil
        var failureHandler: DataResponseError? = nil
        init() { }
    }
    
    // MARK: - Variables
    private var taskData = TaskData()
    private var dispatcher: APIDispatcher?
    
    var request: APIRequest?
    
    // MARK: - Init & deinit
    init(request: APIRequest?) {
        self.request = request
        dispatcher = APIDispatcher()
        set(silentLoad: true)
    }
    
    // MARK: - Builder (public)
    @discardableResult
    func set(responseQueue: DispatchQueue) -> APIOperation<Output> {
        taskData.responseQueue = responseQueue
        return self
    }
    
    @discardableResult
    // Load request without: showing indicator + showing api error alert + request error alert automatically
    func set(silentLoad: Bool) -> APIOperation<Output> {
        taskData.showIndicator = !silentLoad
        taskData.autoShowApiErrorAlert = !silentLoad
        taskData.autoShowRequestErrorAlert = !silentLoad
        return self
    }
    
    @discardableResult
    func showIndicator(_ show: Bool) -> APIOperation<Output> {
        taskData.showIndicator = show
        return self
    }
    
    @discardableResult
    func autoShowApiErrorAlert(_ show: Bool) -> APIOperation<Output> {
        taskData.autoShowApiErrorAlert = show
        return self
    }
    
    @discardableResult
    func autoShowRequestErrorAlert(_ show: Bool) -> APIOperation<Output> {
        taskData.autoShowRequestErrorAlert = show
        return self
    }
    
    @discardableResult
    func didCloseApiErrorDialog(_ handler: @escaping ErrorDialogResponse) -> APIOperation<Output> {
        taskData.didCloseApiErrorDialogHandler = handler
        return self
    }
    
    @discardableResult
    func didCloseRequestErrorDialog(_ handler: @escaping ErrorDialogResponse) -> APIOperation<Output> {
        taskData.didCloseRequestErrorDialogHandler = handler
        return self
    }
    
    @discardableResult
    func didCloseOfflineErrorDialog(_ handler: @escaping OfflineDialogResponse) -> APIOperation<Output> {
        taskData.didCloseOfflineDialogHandler = handler
        return self
    }
    
    // MARK: - Executing functions (public)
    @discardableResult
    func execute(target: UIViewController? = nil, success: DataResponseSuccess? = nil, failure: DataResponseError? = nil) -> APIOperation<Output> {
        func run(queue: DispatchQueue?, body: @escaping () -> Void) {
            (queue ?? .main).async {
                body()
            }
        }
        dispatcher?.target = target
        taskData.successHandler = success
        taskData.failureHandler = failure
        let showIndicator = taskData.showIndicator
        let responseQueue = taskData.responseQueue
        if let request = self.request {
            if showIndicator {
                run(queue: .main) { APIUIIndicator.showIndicator() }
            }
            // Print information of request
            request.printInformation()
            print("▶︎ [\(request.name)] is requesting...")
            
            // Execute request
            dispatcher?.execute(request: request, completed: { [target, request, self] response in
                if showIndicator {
                    run(queue: .main) { APIUIIndicator.hideIndicator() }
                }
                switch response {
                case .success(let json):
                    print("▶︎ [\(request.name)] succeed !")
                    run(queue: responseQueue) {
                        self.callbackSuccess(output: T(json: json))
                    }
                case .error(let error):
                    print("▶︎ [\(request.name)] error message: \"\(error.message ?? "empty")\"")
                    run(queue: responseQueue) {
                        self.callbackError(error: error)
                    }
                }
            })
        } else {
            run(queue: responseQueue) {
                self.callbackError(error: APIError.unknown)
            }
        }
        return self
    }
    
    // MARK: - rx execute function
    
    func rxExecute(target: UIViewController? = nil) -> Observable<Output> {
        return Observable.create { obs in
            let _ = self.execute(target: target, success: { (response) in
                obs.onNext(response)
                obs.onCompleted()
            }, failure: { (error) in
                obs.onError(error)                
            })
            return Disposables.create(with: self.cancel)
        }
    }
    
    func cancel() {
        dispatcher?.cancel()
    }
    
    // MARK: - Handle callback with input data
    private func callbackSuccess(output: T) {
        taskData.successHandler?(output)
    }
    
    private func callbackError(error: APIError) {
        DispatchQueue.main.async {
            self.showErrorAlertIfNeeded(error: error)
        }
        taskData.failureHandler?(error)
    }
    
    // MARK: - Alerts
    private func showErrorAlertIfNeeded(error: APIError) {
        switch error {
        case .api:
            guard taskData.autoShowApiErrorAlert else { return }
            APIUIAlert.showApiErrorDialogWith(error: error, completion: {
                self.taskData.didCloseApiErrorDialogHandler?()
            })

        case .request(_, let requestError):
            guard taskData.autoShowRequestErrorAlert, let requestError = requestError else { return }
            if requestError.isInternetOffline {
                APIUIAlert.showOfflineErrorDialog(completion: { index, tapRetry in
                    if tapRetry {
                        self.execute(target: self.dispatcher?.target,
                                     success: self.taskData.successHandler,
                                     failure: self.taskData.failureHandler)
                    }
                })
            } else {
                APIUIAlert.showRequestErrorDialogWith(error: error, completion: {
                    self.taskData.didCloseRequestErrorDialogHandler?()
                })
            }
        }
    }
}
