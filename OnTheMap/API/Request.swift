//
//  Request.swift
//  OnTheMap
//
//  Created by Chris Eadie on 11/12/2020.
//

import Foundation

class OnTheMapAPI {
    static let scheme = "https"
    static let host = "onthemap-api.udacity.com/v1/"
    
    struct Path {
        static let studentLocation = "StudentLocation"
        static let session = "session"
        
        func userId(_ id: Int) -> String {
            return "/users/\(id)"
        }
    }
    
    enum Params {
        case limit(Int)
        case skip(Int)
        case order(Order)
        case uniqueKey(String)
        
        var asQueryItem: URLQueryItem {
            switch self {
            case .limit(let limitValue):
                return URLQueryItem(name: "limit", value: "\(limitValue)")
            case .skip(let skipValue):
                return URLQueryItem(name: "skip", value: "\(skipValue)")
            case .order(let orderValue):
                return URLQueryItem(name: "order", value: orderValue.asString)
            case .uniqueKey(let keyValue):
                return URLQueryItem(name: "", value: keyValue)
            }
        }
        
        enum Order: String {
            case updatedAtAscending
            case updatedAtDescending
            
            var asString: String {
                switch self {
                case .updatedAtAscending:
                    return "updatedAt"
                case .updatedAtDescending:
                    return "-updatedAt"
                }
            }
        }
    }
    
    class func getLocations() {
        var urlComponents = URLComponents()
        urlComponents.scheme = OnTheMapAPI.scheme
        urlComponents.host = OnTheMapAPI.host
        urlComponents.path = OnTheMapAPI.Path.studentLocation
        urlComponents.queryItems = [
            OnTheMapAPI.Params.limit(100).asQueryItem,
            OnTheMapAPI.Params.order(.updatedAtDescending).asQueryItem
        ]
        
        guard let url = urlComponents.url else {
            fatalError()
        }
        
        print("\(url)")
    }
}
