//
//  UIViewController+Extension.swift
//  Arum
//
//  Created by trinhhc on 5/26/21.
//

import RxCocoa
import MBProgressHUD

extension UIViewController {
    var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            var message = ""
            if let localizedFailureReason = error.localizedFailureReason {
                message = localizedFailureReason
            }
            
            if message.isEmpty {
                message = "エラーが発生しました"
            }
            self.alertBinding.onNext(message)
        })
    }
    
    var alertBinding: Binder<String> {
        return Binder(self, binding: { (vc, message) in
            let alert = UIAlertController(title: "",
                                          message: message,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "OK",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
    
    var alertBindingPopOnCompleted: Binder<String> {
        return Binder(self, binding: { (vc, message) in
            let alert = UIAlertController(title: "",
                                          message: message,
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "OK",
                                       style: UIAlertAction.Style.cancel) { [weak self](action) in
                self?.navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
    
    var activityIndicatorEntireScreenBinder: Binder<Bool> {
        return Binder(self, binding: { (vc, isLoadingEntireView) in
            if isLoadingEntireView {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        })
    }
}
