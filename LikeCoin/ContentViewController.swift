//
//  ContentViewController.swift
//  LikeCoin
//
//  Created by David Ng on 21/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit
import WebKit

class ContentViewController: CommonViewController {
    
    var webView: WKWebView!
    var content: Content!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.processPool = WKProcessPool()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
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
                    self.webView.load(URLRequest(url: self.content.url))
                }
            }
        }
    }
}

