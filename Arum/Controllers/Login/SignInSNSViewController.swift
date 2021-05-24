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
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.load(URLRequest(url: url))
    }
    
    func loadWeb

}
