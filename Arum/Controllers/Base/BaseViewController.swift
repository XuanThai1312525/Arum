//
//  BaseViewController.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
import UIKit

typealias backButtonActionHandler = ()->()
class BaseVC: UIViewController {
    
    // MARK: - Init & deinit
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.notifyLanguageChanged), name: CGLNotificationName.changeLanguage.value, object: nil)
        self.navigationBarWithBackTitle(title: "" )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false

    }
    
    lazy var back: UIBarButtonItem? = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backIcon"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: UIControl.Event.touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.contentHorizontalAlignment = .left
        return UIBarButtonItem(customView: backButton)

    }()
    
    var hideBackButton: Bool = false {
        didSet {
            if self.hideBackButton == true {
                self.navigationItem.hidesBackButton = true
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    func navigationBarWithBackTitle(title: String, prefersLargeTitles: Bool = false) {
        self.navigationItem.title = title
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        } else {
            // Fallback on earlier versions
        }
        self.navigationItem.leftBarButtonItem = back
    }
    
    @objc func notifyLanguageChanged(_ notify: Notification) {

    }
    
    @objc func backButtonTapped() {
        guard let navVC = self.navigationController, let _ =  self.back else { return }
        navVC.popViewController(animated: true)
    }
}
