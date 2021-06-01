//
//  LoadingViewController.swift
//  Arum
//
//  Created by trinhhc on 5/27/21.
//

import RxSwift

class LoadingViewController: HideNavigationBarViewController {

    //MARK: Properties
    let viewModel = LoadingViewModel()
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewController = UIStoryboard.init(name: "LaunchScreen", bundle: Bundle.main).instantiateInitialViewController()!
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
        self.view.sendSubviewToBack(viewController.view)
    }
    
    override func setupViewModel() {
        super.setupViewModel()
        
        let output = viewModel.transform(input: LoadingViewModel.Input(checkDeviceTrigger: Observable.just(())))
        output.errorTracking
            .subscribe { (event) in
                
            }
            .disposed(by: disposeBag)
        
        output.activityIndicator
            .bind(to: self.activityIndicatorEntireScreenBinder)
            .disposed(by: disposeBag)
        
        output.checkingSuccess
            .bind { (event) in
            }
            .disposed(by: disposeBag)
        
    }

}
