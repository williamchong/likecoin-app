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

    override func awakeFromNib() {
        super.awakeFromNib()
        empty()
    }

    func empty() {
        displayNameLabel.text = ""
        titleLabel.text = ""
        descriptionLabel.text = ""
    }

    func setContent(_ content: Content!) {
        displayNameLabel.text =  "\(content.creatorLikerID) | \(content.likeCount) LIKE"
        titleLabel.text = content.title
        descriptionLabel.text = content.description
    }
}
