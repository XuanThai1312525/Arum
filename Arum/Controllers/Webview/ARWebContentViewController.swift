//
//  ARWebContentViewController.swift
//  Arum
//
//  Created by Admim on 5/15/21.
//

import UIKit
import WebKit

final class ARWebContentViewController: HideNavigationBarViewController {

    @IBOutlet weak var contentWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configs()
    }
    
    private func configs() {
        guard let url = URL(string: Constants.BASE_URL) else {return}
        let urlRequest = URLRequest(url: url)
        contentWebView.load(urlRequest)
        contentWebView.scrollView.showsVerticalScrollIndicator = false
    }
}

extension ARWebContentViewController: WKNavigationDelegate {}


