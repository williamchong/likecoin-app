//
//  HomeViewController.swift
//  LikeCoin
//
//  Created by David Ng on 21/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit

protocol HomeViewDelegate {
    func onClickLogoutButton()
}

class HomeViewController: UITabBarController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var userLabel: UILabel!

    var viewDelegate: HomeViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func onClickLogoutButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        viewDelegate?.onClickLogoutButton()
    }
}
