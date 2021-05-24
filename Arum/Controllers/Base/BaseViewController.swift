//
//  BaseViewController.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import RxSwift
import RxCocoa
import MBProgressHUD

typealias backButtonActionHandler = ()->()
class BaseVC: UIViewController {
    
    // MARK: - @objc @objc @objc Init & deinit
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("▶︎ [Screen - \(self.name)] deinit !")
    }
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        baseConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed || isMovingFromParent {
            // Detect current controller is being dismissed
            handleWhenViewIsBeingDismissedOrPopped()
        }
    }
    
    // MARK: - Setup
    private func baseConfig() {
        edgesForExtendedLayout = []
        
    }
    
    // MARK: - Action
    private func handleWhenViewIsBeingDismissedOrPopped() {
        cancelAllAPIRequests()
    }
    
    
}




class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.notifyLanguageChanged), name: CGLNotificationName.changeLanguage.value, object: nil)
        setupNavigationBar()
        setupUI()
        setupTap()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    lazy var back: UIButton = {
        let backButton = UIButton()
        backButton.setImage(R.image.ic_back(), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: UIControl.Event.touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        backButton.contentHorizontalAlignment = .left
        backButton.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        return backButton
        
    }()
    
    var hideBackButton: Bool = false {
        didSet {
            if self.hideBackButton == true {
                self.navigationItem.hidesBackButton = true
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    func navigationBarWithBackTitle(title: String, backTitle: String,backTitleColor: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1),backTitleFont: UIFont = UIFont.appleSDGothicNeo.regular.font(size: 21), prefersLargeTitles: Bool = false) {
        self.navigationItem.title = title
        //
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        } else {
            // Fallback on earlier versions
        }
        
        let backButton = UIBarButtonItem(customView: back)
        
        let backButtonTitleAttibute = NSAttributedString(string: backTitle, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1),
            NSAttributedString.Key.font: backTitleFont
        ])
        back.setAttributedTitle(backButtonTitleAttibute, for: .normal)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func notifyLanguageChanged(_ notify: Notification) {
        
    }
    
    @objc func backButtonTapped() {
        guard let navVC = self.navigationController else { return }
        navVC.popViewController(animated: true)
    }
}



//MARK: Binding
extension BaseViewController {
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

//MARK: Life cycles
extension BaseViewController {
    @objc func setupNavigationBar() {
    }
    
    /// For general ui setup
    @objc func setupUI() {
        
    }
    
    ///For tap on button
    @objc func setupTap() {
        
    }
    
    @objc func setupViewModel() {
    }
}

