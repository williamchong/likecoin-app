//
//  ContentTableViewCell.swift
//  LikeCoin
//
//  Created by David Ng on 21/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func fetchInfo(url: String) {
        displayNameLabel.text = " "
        titleLabel.text = " "
        descriptionLabel.text = " "

        Alamofire
            .request(LikeCoinPublicAPI.likeInfo(url: url))
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.displayNameLabel.text = "\(json["user"].stringValue) | \(json["like"].intValue) LIKE"
                    self.titleLabel.text = json["title"].stringValue
                    self.descriptionLabel.text = json["description"].stringValue

                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
