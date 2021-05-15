//
//  APIProcessingManager.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/18/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit
import Alamofire

class APIProcessingManager {
    
    // MARK: - Singleton
    static let instance = APIProcessingManager()
    
    // MARK: - Variables
    private var processingDispatcherList: [APIDispatcher] = []
    
    // MARK: - Init & deinit
    init() {
        // Init method
    }
    
    // MARK: - Builder
    func add(dispatcher: APIDispatcher) {
        processingDispatcherList.append(dispatcher)
        print("▶︎ [API Processing Manager] Added new request !")
    }
    
    func cancel(dispatcher: APIDispatcher) {
        dispatcher.cancel()
        print("▶︎ [API Processing Manager] Cancelled request for screen: [\(dispatcher.target?.name ?? "none") !")
    }
    
    func cancelAllDispatchers() {
        processingDispatcherList.forEach {
            $0.cancel()
        }
        processingDispatcherList.removeAll()
    }
    
    func cancelAllDispatchersFor(target: UIViewController) {
        let filterDispatcherList = processingDispatcherList.filter({ $0.target == target })
        for dispatcher in filterDispatcherList {
            dispatcher.cancel()
        }
    }
    
    func removeDispatcherFromList(dispatcher: APIDispatcher) {
        if let index = processingDispatcherList.index(where: { $0 === dispatcher }) {
            processingDispatcherList.remove(at: index)
        }
    }
}

extension UIViewController {
    func cancelAllAPIRequests() {
        APIProcessingManager.instance.cancelAllDispatchersFor(target: self)
    }
}
