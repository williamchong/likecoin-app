//
//  API.swift
//  LikeCoin
//
//  Created by David Ng on 19/8/2019.
//  Copyright © 2019 LikeCoin Foundation Limited. All rights reserved.
//

import Alamofire

enum LikeCoinAPI: URLRequestConvertible {
    case userSelf
    case userLogin(platform: String, email: String, firebaseIdToken: String)
    case userLogout
    
    static let baseURLString = "https://like.co"
    
    var method: HTTPMethod {
        switch self {
        case .userSelf:
            return .get
        case .userLogin:
            return .post
        case .userLogout:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .userSelf:
            return "/api/users/self"
        case .userLogin:
            return "/api/users/login"
        case .userLogout:
            return "/api/users/logout"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try LikeCoinAPI.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .userLogin(let platform, let email, let firebaseIdToken):
            let parameters: Parameters = [
                "platform": platform,
                "email": email,
                "firebaseIdToken": firebaseIdToken,
            ]
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                // No-op
            }
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        default:
            break
        }

        return urlRequest
    }
}

enum LikerLandAPI: URLRequestConvertible {
    case userLogin
    case userLogout
    case readerSuggest
    case readerFollowed
    
    static let baseURLString = "https://liker.land"
    
    var method: HTTPMethod {
        switch self {
        case .userLogin:
            return .get
        case .userLogout:
            return .post
        case .readerSuggest:
            return .get
        case .readerFollowed:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .userLogin:
            return "/api/users/login"
        case .userLogout:
            return "/api/users/logout"
        case .readerSuggest:
            return "/api/reader/works/suggest"
        case .readerFollowed:
            return "/api/reader/works/followed"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try LikerLandAPI.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

enum LikeCoinPublicAPI: URLRequestConvertible {
    case likeInfo(url: String)

    static let baseURLString = "https://api.like.co"

    var method: HTTPMethod {
        switch self {
        case .likeInfo:
            return .get
        }
    }

    var path: String {
        switch self {
        case .likeInfo:
            return "/like/info"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try LikeCoinPublicAPI.baseURLString.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .likeInfo(let url):
            let parameters: Parameters = ["url": url]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
        default:
            break
        }

        return urlRequest
    }
}
