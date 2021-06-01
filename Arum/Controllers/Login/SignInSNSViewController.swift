//
//  SignInSNSViewController.swift
//  Arum
//
//  Created by trinhhc on 5/24/21.
//

import UIKit
import WebKit

class SignInSNSViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeb()
    }
    
    func loadWeb() {
        guard let url = url, let webUrl = URL(string: url) else {
            return
        }
        
        webview.load(URLRequest(url: webUrl))
        
    }

}
