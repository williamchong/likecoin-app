//
//  AlertController.swift
//  LikeCoin
//
//  Created by David Ng on 20/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {
    func alert(title: String, message: String) -> Void {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertError(_ error: Error) -> Void {
        print(error.localizedDescription)
        alert(title: "Error", message: error.localizedDescription)
    }
}
