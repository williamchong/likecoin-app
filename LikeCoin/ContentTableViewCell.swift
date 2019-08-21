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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func fetchInfo(url: String) {
        Alamofire
            .request(LikeCoinPublicAPI.likeInfo(url: url))
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.textLabel?.text = "\(json["user"].stringValue) | \(json["title"].stringValue)"
                    self.detailTextLabel?.text = json["description"].stringValue

                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
