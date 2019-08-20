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

class ViewController: CommonViewController, FUIAuthDelegate {

    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var authButton: UIButton!
    
    let sessionManager = Alamofire.SessionManager.default
    var user: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfoFromAPI { (json, _) in
            self.setUserWith(json: json)
        }
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            alertError(error)
            return
        }

        let user = authDataResult!.user
        user.getIDToken { (idToken, getIDTokenError) in
            if let error = getIDTokenError {
                print(error.localizedDescription)
                return
            }

            self.sessionManager
                .request(LikeCoinAPI.userLogin(platform: "google", email: user.email!, firebaseIdToken: idToken!))
                .validate()
                .responseString { response in
                    switch response.result {
                    case .success:
                        self.getUserInfoFromAPI { (json, error) in
                            if let error = error {
                                self.alert(title: "Error on getting user info", message: error.localizedDescription)
                                return
                            }
                            self.setUserWith(json: json)
                        }
                    case .failure(let error):
                        self.alert(title: "Error on login", message: error.localizedDescription)
                    }
                }
        }
    }

    func setUserWith(json: JSON?) {
        self.user = json
        guard let user = json else {
            authButton.setTitle("Login", for: .normal)
            self.userInfoLabel.text = ""
            return
        }
        authButton.setTitle("Logout", for: .normal)
        userInfoLabel.text = "You are logged in as \(user["user"])";
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI!.delegate = self
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
        ]
        authUI!.providers = providers
        
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            sessionManager
                .request(LikeCoinAPI.userLogout)
                .validate()
                .responseString { response in
                    switch response.result {
                    case .success:
                        self.setUserWith(json: nil)
                    case .failure(let error):
                        self.alert(title: "Error on logout", message: error.localizedDescription)
                    }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getUserInfoFromAPI(completion: @escaping (JSON?, Error?) -> Void) {
        sessionManager
            .request(LikeCoinAPI.userSelf)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    completion(json, nil)
                    
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

    @IBAction func handleClickAuthButton(_ sender: Any) {
        if user != nil {
            logout()
        } else {
            login()
        }
    }
}

