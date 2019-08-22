//
//  FollowingContentTableViewController.swift
//  LikeCoin
//
//  Created by David Ng on 21/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import UIKit
import Alamofire

class FollowingContentTableViewController: ContentTableViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentAPI = LikerLandAPI.readerFollowed
    }
}
