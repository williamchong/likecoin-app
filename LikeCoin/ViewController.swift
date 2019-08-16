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

class ViewController: UIViewController, FUIAuthDelegate {

    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var authButton: UIButton!
    
    var isLoggedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()

        set(isLoggedIn: Auth.auth().currentUser != nil)
    }

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        print(authDataResult!.user)
        
        set(isLoggedIn: true)
    }
    
    func set(isLoggedIn: Bool) {
        if isLoggedIn {
            authButton.setTitle("Logout", for: .normal)
            userInfoLabel.text = "You are logged in as \(Auth.auth().currentUser?.email ?? "")";
        } else {
            authButton.setTitle("Login", for: .normal)
            userInfoLabel.text = ""
        }
        self.isLoggedIn = isLoggedIn
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
            set(isLoggedIn: false)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    @IBAction func handleClickAuthButton(_ sender: Any) {
        if isLoggedIn {
            logout()
        } else {
            login()
        }
    }
}

