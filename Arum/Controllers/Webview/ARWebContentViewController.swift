//
//  ARWebContentViewController.swift
//  Arum
//
//  Created by Admim on 5/15/21.
//

import UIKit
import WebKit
import WKWebViewJavascriptBridge

final class ARWebContentViewController: HideNavigationBarViewController {

    var contentWebView: WKWebView!
    var bridge: WKWebViewJavascriptBridge!
    var urlString: String? {
        didSet {
            if (isViewLoaded) {
                request()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func makeRequest() -> URLRequest? {
        guard let url = URL(string: urlString ?? Constants.BASE_URL) else {return nil}
        return URLRequest(url: url)
    }
    
    private func request() {
        guard var urlRequest = makeRequest() else {return}
        if let cookie = UserSession.getSessionCookie() {
            urlRequest.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: [cookie])
        }
        contentWebView.load(urlRequest)
    }
    
    private func configs() {
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        contentWebView = WKWebView(frame: .zero, configuration: config)
        view.addSubview(contentWebView)
        contentWebView.fullscreen()
        contentWebView.scrollView.showsVerticalScrollIndicator = false
        contentWebView.navigationDelegate = self
        contentWebView.allowsLinkPreview = false
        request()
        bridge = WKWebViewJavascriptBridge(webView: contentWebView)
    }
    
    private func listenWebview() {
        
    }
    
    private func directToLoginView() {
        func presentLoginView() {
            let vc = SignInViewController(nib: R.nib.signInViewController)
            present(vc, animated: true, completion: nil)
        }
        
        guard let nav = navigationController else {
            presentLoginView()
            return
        }
        
        if let vc = nav.viewControllers.last(where: {$0.isKind(of: SignInViewController.self)}) {
            pop(to: vc)
        } else {
            let vc = SignInViewController(nib: R.nib.signInViewController)
            nav.pushViewController(vc, animated: true)
        }
    }
}

extension ARWebContentViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        /*
        let dataStore = webView.configuration.websiteDataStore
        let cookieStore = dataStore.httpCookieStore
        cookieStore.getAllCookies { (cookies) in}
        */
        if let url = webView.url, url.absoluteString == "https://aleum.kr/login?url=%2Fnote" {
            decisionHandler(.cancel)
            directToLoginView()
            return
        }
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

