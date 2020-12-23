//
//  API.swift
//  OnTheMap
//
//  Created by Chris Eadie on 23/12/2020.
//

import Foundation

class OnTheMapAPI {
    
    struct Session {
        static var id: String?
    }
    
    enum Endpoints {
        static let apiBase = "https://onthemap-api.udacity.com"
        
        static let studentLocationPath = "/v1/StudentLocation"
        static let sessionPath = "/v1/session"
        
        static let limitParam = "limit=200"
        static let skipParam = "skip=200"
        static let orderParam = "order=-updatedAt"
        static let uniqueKeyParam = "uniqueKey=ABC"
        
        case getLocations
        case location
        case session
        
        var stringValue: String {
            switch self {
            case .getLocations:
                return "\(Endpoints.apiBase)\(Endpoints.studentLocationPath)?\(Endpoints.limitParam)&\(Endpoints.orderParam)"
            case .location:
                return "\(Endpoints.apiBase)\(Endpoints.studentLocationPath)"
            case .session:
                return "\(Endpoints.apiBase)\(Endpoints.sessionPath)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    struct UdacityLogin: Codable {
        let udacity: LoginDetails
        
        struct LoginDetails: Codable {
            let email: String
            let password: String
        }
    }
    
    struct LocationForPosting: Codable {
        let uniqueKey: String
        let firstName: String
        let lastName: String
        let mapString: String
        let mediaURL: String
        let latitude: Double
        let longitude: Double
    }
}
