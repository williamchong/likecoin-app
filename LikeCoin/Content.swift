//
//  Content.swift
//  LikeCoin
//
//  Created by David Ng on 26/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import SwiftyJSON

class Content {
    var url: URL!
    var creatorLikerID: String = ""
    var imageURL: URL?
    var title: String = ""
    var description: String = ""
    var likeCount: Int64 = 0

    init(url: URL, json: JSON) {
        self.url = url
        if let url = URL(string: json["url"].stringValue) {
            self.url = url
        }
        creatorLikerID = json["user"].stringValue
        title = json["title"].stringValue
        description = json["description"].stringValue
        imageURL = URL(string: json["image"].stringValue)
        likeCount = json["like"].int64Value
    }
}
