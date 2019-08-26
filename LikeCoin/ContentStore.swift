//
//  ContentStore.swift
//  LikeCoin
//
//  Created by David Ng on 26/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import SwiftyJSON
import Alamofire

class ContentStore {

    static let shared = ContentStore()

    private var dict: [String: Content]!

    private init() {
        dict = [:]
    }

    func getContent(url: URL) -> Content? {
        return dict[url.absoluteString]
    }

    func getContentAsync(url: URL, completionHandler: @escaping (Content?, Error?) -> Void) {
        Alamofire
            .request(LikeCoinPublicAPI.likeInfo(url: url.absoluteString))
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let content = Content(url: url, json: json)
                    self.cacheContent(content)
                    completionHandler(content, nil)

                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(nil, error)
                }
        }
    }

    private func cacheContent(_ content: Content?) {
        if let content = content, let url = content.url {
            dict[url.absoluteString] = content
        }
    }
}
