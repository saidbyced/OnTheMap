//
//  Request.swift
//  OnTheMap
//
//  Created by Chris Eadie on 11/12/2020.
//

import Foundation

class OnTheMapAPI {
    static let scheme = "https"
    static let host = ""
    static let path = ""
    
    enum Params {
        case limit(Int)
        case skip(Int)
        case order(String)
        case uniqueKey(String)
        
        var asQueryItem: URLQueryItem {
            switch self {
            case .limit(let limitValue):
                return URLQueryItem(name: "limit", value: "\(limitValue)")
            case .skip(let skipValue):
                return URLQueryItem(name: "skip", value: "\(skipValue)")
            case .order(let orderValue):
                return URLQueryItem(name: "order", value: orderValue)
            case .uniqueKey(let keyValue):
                return URLQueryItem(name: "", value: keyValue)
            }
        }
    }
    
    class func getLocations() {
        var urlComponents = URLComponents()
        urlComponents.scheme = OnTheMapAPI.scheme
        urlComponents.host = OnTheMapAPI.host
        urlComponents.path = OnTheMapAPI.path
        urlComponents.queryItems = [
            OnTheMapAPI.Params.limit(100).asQueryItem
        ]
        
        guard let url = urlComponents.url else {
            fatalError()
        }
        
        print("\(url)")
    }
}
