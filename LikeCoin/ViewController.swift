//
//  ViewController.swift
//  LikeCoin
//
//  Created by David Ng on 7/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import Alamofire
import SwiftyJSON

class ViewController: CommonViewController, FUIAuthDelegate, LikerLandOAuthDelegate, HomeViewDelegate {

    let sessionManager = Alamofire.SessionManager.default
    var user: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfoFromAPI { (json, _) in
            if json != nil {
                self.setUserWith(json: json)
                self.performSegue(withIdentifier: "showHome", sender: self)
            } else {
                self.showLoginPortal()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showLikerLandOAuthView":
            let vc = segue.destination as! LikerLandOAuthViewController
            vc.delegate = self
        case "showHome":
            let vc = segue.destination as! HomeViewController
            vc.userLabel.text = "\(user?["user"] ?? "")"
            vc.viewDelegate = self
        default:
            break
        }
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            alertError(error)
            return
        }

        let hud = showLoadingHUD(text: "Logging in")
        let user = authDataResult!.user
        user.getIDToken { (idToken, getIDTokenError) in
            if let error = getIDTokenError {
                print(error.localizedDescription)
                hud.hide(animated: true)
                return
            }

            self.sessionManager
                .request(LikeCoinAPI.userLogin(platform: "google", email: user.email!, firebaseIdToken: idToken!))
                .validate()
                .responseString { response in
                    hud.hide(animated: true)
                    switch response.result {
                    case .success:
                        self.getUserInfoFromAPI { (json, error) in
                            if let error = error {
                                self.alert(title: "Error on getting user info", message: error.localizedDescription)
                                return
                            }
                            self.setUserWith(json: json)

                            self.performSegue(withIdentifier: "showLikerLandOAuthView", sender: self)
                        }
                    case .failure(let error):
                        self.alert(title: "Error on login", message: error.localizedDescription)
                    }
                }
        }
    }
    
    func likerLandDidFinishOAuthRedirect() {
        performSegue(withIdentifier: "showHome", sender: self)
    }

    func likerLandDidFailOAuthRedirect() {
        self.performSegue(withIdentifier: "showLikerLandOAuthView", sender: self)
    }

    func onClickLogoutButton() {
        logout()
    }

    func setUserWith(json: JSON?) {
        self.user = json
    }
    
    func showLoginPortal() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
        ]
        authUI?.providers = providers
        authUI?.shouldHideCancelButton = true
        
        if let authViewController = authUI?.authViewController() {
            present(authViewController, animated: true, completion: nil)
        }
    }
    
    func logout() {
        let hud = showLoadingHUD(text: "Logging out")
        do {
            try Auth.auth().signOut()
            sessionManager
                .request(LikerLandAPI.userLogout)
                .validate()
                .responseString { response in
                    switch response.result {
                    case .success:
                        self.setUserWith(json: nil)
                    case .failure(let error):
                        hud.hide(animated: true)
                        self.alert(title: "Error on liker.land logout", message: error.localizedDescription)
                    }
                    self.sessionManager
                        .request(LikeCoinAPI.userLogout)
                        .validate()
                        .responseString { response in
                            hud.hide(animated: true)
                            switch response.result {
                            case .success:
                                self.setUserWith(json: nil)
                                self.showLoginPortal()
                            case .failure(let error):
                                self.alert(title: "Error on like.co logout", message: error.localizedDescription)
                            }
                    }
                }
        } catch let error as NSError {
            print(error.localizedDescription)
            hud.hide(animated: true)
        }
    }
    
    func getUserInfoFromAPI(completion: @escaping (JSON?, Error?) -> Void) {
        let hud = showLoadingHUD(text: "Getting user info")
        sessionManager
            .request(LikeCoinAPI.userSelf)
            .validate()
            .responseJSON { response in
                hud.hide(animated: true)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    completion(json, nil)
                    
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
}

