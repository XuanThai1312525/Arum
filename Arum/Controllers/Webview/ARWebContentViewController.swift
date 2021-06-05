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

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var containerWebview: UIView!
    
    var contentWebView: WKWebView!
    var bridge: WKWebViewJavascriptBridge!
    var popupWebView: WKWebView?
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
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        contentWebView = WKWebView(frame: .zero, configuration: config)
        contentWebView.uiDelegate = self
        containerWebview.addSubview(contentWebView)
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
    
        
        guard let url = webView.url else { return }
        let absoluteString =  url.absoluteString
        if absoluteString == "https://aleum.kr/login?url=%2Fnote" {
            decisionHandler(.cancel)
            directToLoginView()
            return
        }
        
        if absoluteString.contains("login-sns") || absoluteString.contains("facebook.com") {
            navigator.setHideBackButton(shouldShow: false)
        } else {
            navigator.setHideBackButton(shouldShow: true)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("====> \(webView.evaluateJavaScript("document.body.style.backgroundColor = '#4287f5';", completionHandler: nil))")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
    
}

extension ARWebContentViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.frame, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        view.addSubview(popupWebView!)
        return popupWebView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if let popupWebView = popupWebView, popupWebView.isDescendant(of: view) {
            popupWebView.removeFromSuperview()
        }
    }
}

