//
//  ARWebContentViewController.swift
//  Arum
//
//  Created by Admim on 5/15/21.
//

import UIKit
import WebKit

final class ARWebContentViewController: BaseViewController {

    var contentWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func configs() {
        guard let url = URL(string: Constants.BASE_URL) else {return}
        let urlRequest = URLRequest(url: url)
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        contentWebView = WKWebView(frame: .zero, configuration: config)
        view.addSubview(contentWebView)
        contentWebView.fullscreen()
        contentWebView.load(urlRequest)
        contentWebView.scrollView.showsVerticalScrollIndicator = false
        contentWebView.navigationDelegate = self
        contentWebView.allowsLinkPreview = false
    }
}

extension ARWebContentViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        /*
        let dataStore = webView.configuration.websiteDataStore
        let cookieStore = dataStore.httpCookieStore
        cookieStore.getAllCookies { (cookies) in}
        */
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.style.webkitTouchCallout='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.body.style.KhtmlUserSelect='none'") { (result, error) in
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
    
}

