//
//  ARWebContentViewController.swift
//  Arum
//
//  Created by Admim on 5/15/21.
//

import UIKit
import WebKit
import WebViewJavascriptBridge

final class ARWebContentViewController: HideNavigationBarViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var containerWebview: UIView!
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    
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
    
    var cookies: [HTTPCookie]?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configs()
    }
    
    override func setupUI() {
        if (SystemInfo.hasTopNotch) {
            topHeightConstraint.constant = 34
        } else {
            topHeightConstraint.constant = 20
        }
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
        if let cookies = cookies {
            urlRequest.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
        } else {
            var url = URL.init(string: Constants.BASE_URL + "/" + Constants.APIPaths.authentication.login)
            if let urlString = urlString {
                url = URL(string: urlString)
            }
            if let url = url, let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                urlRequest.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
            }
        }
        contentWebView.load(urlRequest)
    }
    
    private func buttonClickEventTriggeredScriptToAddToDocument() -> String {
        "document.addEventListener('click', function(){ window.webkit.messageHandlers.showLogin.postMessage('click clack!'); })"
    }
    
    private func configs() {
        let contentController = WKUserContentController()
//        let js:String = buttonClickEventTriggeredScriptToAddToDocument()
//        let userScript:WKUserScript =  WKUserScript(source: js,
//                                                 injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
//                                                 forMainFrameOnly: false)
//        contentController.addUserScript(userScript)
//        contentController.add(self, name: "showLogin")
        
        let removeLocationJS = """
        navigator.geolocation.getCurrentPosition = function(success, error, options) {
            error({
                PERMISSION_DENIED: 1,
                code: 1
            });
        };
        """

        let removeLocation = WKUserScript(source: removeLocationJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        contentController.addUserScript(removeLocation)
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        config.preferences = preferences
        contentWebView = WKWebView(frame: .zero, configuration: config)
        contentWebView.uiDelegate = self
        containerWebview.addSubview(contentWebView)
        contentWebView.fullscreen()
        contentWebView.scrollView.showsVerticalScrollIndicator = false
        contentWebView.scrollView.contentInsetAdjustmentBehavior = .never
        contentWebView.scrollView.bounces = false
        contentWebView.navigationDelegate = self
        contentWebView.allowsLinkPreview = false
        contentWebView.backgroundColor = .clear
        request()
        bridge = WKWebViewJavascriptBridge(for: contentWebView)
        bridge.setWebViewDelegate(self)
        listenWebview()
    }
    
    private func listenWebview() {
        
        bridge.registerHandler("showLogin") { (data, callback) in
            callback?(data)
            DispatchQueue.main.async {
                self.navigator.directToLoginView(context: NavigationContext().fromVC(self))
            }
        }
        
        bridge.registerHandler("getAppInfo") { (data, callback) in
            let dataName = [
                "os": "IOS",
                "token": UserSession.UUID_TOKEN ?? "",
                "version": Bundle.main.getAppVersion()
            ]

            callback?(dataName)
        }
        
    }

}

extension ARWebContentViewController: WKNavigationDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
       
        
        
        guard let url = webView.url else { return }
//        let dataStore = webView.configuration.websiteDataStore
//        let cookieStore = dataStore.httpCookieStore
//        cookieStore.getAllCookies { (cookies) in
//            print("=====> \(cookies) of \(url.absoluteString) <=====")
//        }
        let absoluteString =  url.absoluteString
        if absoluteString.contains("https://aleum.kr/login?url=") {
            navigator.directToLoginView(context: NavigationContext().fromVC(self))
            decisionHandler(.cancel)
            return
        }
        
        if absoluteString.contains("login-sns") || absoluteString.contains("facebook.com") {
            self.navigationItem.setHidesBackButton(false, animated: false)
        } else {
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("====> \(message)")
    }
    
}

extension ARWebContentViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.frame, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        popupWebView?.scrollView.showsVerticalScrollIndicator = false
        popupWebView?.backgroundColor = .white
        popupWebView?.scrollView.backgroundColor = .white
        popupWebView?.isOpaque = false
        view.addSubview(popupWebView!)
        return popupWebView

    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if let popupWebView = popupWebView, popupWebView.isDescendant(of: view) {
            popupWebView.removeFromSuperview()
        }
    }
    
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        let title = NSLocalizedString("확인", comment: "확인")
//        let ok = UIAlertAction(title: title, style: .default) { (_: UIAlertAction) -> Void in
//            // alert.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(ok)
//        present(alert, animated: true)
        completionHandler()
    }
    
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel, preferences)
        } else {
            decisionHandler(.allow, preferences)
        }
    }

}

