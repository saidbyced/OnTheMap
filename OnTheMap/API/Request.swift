//
//  Request.swift
//  OnTheMap
//
//  Created by Chris Eadie on 11/12/2020.
//

import Foundation

struct OnTheMapAPI {
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
    
    static func getLocations(completion: @escaping ([Location]?, Error?) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = OnTheMapAPI.scheme
        urlComponents.host = OnTheMapAPI.host
        urlComponents.path = OnTheMapAPI.Path.studentLocation
        urlComponents.queryItems = [
            OnTheMapAPI.Params.limit(100).asQueryItem,
            OnTheMapAPI.Params.order(.updatedAtDescending).asQueryItem
        ]
        
        guard let url = urlComponents.url else {
            // FIXME: Handle url creation error failure
            print("URL creation failed")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // FIXME: Handle request failure error response
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                // FIXME: Handle missing data error
                completion(nil, error)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(StudentLocationsResponse.self, from: data)
                let locations = decodedData.results
                completion(locations, nil)
            } catch {
                // FIXME: Handle JSON parsing error
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
}
