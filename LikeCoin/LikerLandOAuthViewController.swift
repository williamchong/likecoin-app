//
//  WebViewController.swift
//  LikeCoin
//
//  Created by David Ng on 20/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

protocol LikerLandOAuthDelegate {
    func likerLandDidFinishOAuthRedirect()
    func likerLandDidFailOAuthRedirect()
}

class LikerLandOAuthViewController: CommonViewController, WKNavigationDelegate {
    
    var delegate: LikerLandOAuthDelegate?
    var webView: WKWebView!
    var request: URLRequest?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.processPool = WKProcessPool()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let likeCoinURL = URL(string: LikeCoinAPI.baseURLString)!
        let cookies = HTTPCookieStorage.shared.cookies(for: likeCoinURL)
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        for cookie in cookies! {
            cookieStore.setCookie(cookie) {
                if cookie.name == "likecoin_auth" {
                    do {
                        self.request = try LikerLandAPI.userLogin.asURLRequest()
                        self.webView.load(self.request!)
                        _ = self.showLoadingHUD(text: "Logging in to Liker.Land")
                    } catch {
                        // No-op
                    }
                }
            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let urlString = webView.url?.absoluteString {
            if urlString.hasPrefix(LikerLandAPI.baseURLString + "/oauth/redirect") {
                webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                    for cookie in cookies {
                        HTTPCookieStorage.shared.setCookie(cookie)
                        if cookie.name == "__session" {
                            self.dismiss(animated: false, completion: nil)
                            self.delegate?.likerLandDidFinishOAuthRedirect()
                        }
                    }
                }
            } else if urlString.contains("/in/register") {
                self.dismiss(animated: false, completion: nil)
                self.delegate?.likerLandDidFailOAuthRedirect()
            }
        }
    }
}

