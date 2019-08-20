//
//  AlertController.swift
//  LikeCoin
//
//  Created by David Ng on 20/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit
import MBProgressHUD

class CommonViewController: UIViewController {
    func alert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) -> Void {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertError(_ error: Error) -> Void {
        print(error.localizedDescription)
        alert(title: "Error", message: error.localizedDescription)
    }
    
    func showLoadingHUD(text: String? = nil) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        if text != nil {
            hud.detailsLabel.text = text
        }
        return hud
    }
}
