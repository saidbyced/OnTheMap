//
//  Client.swift
//  OnTheMap
//
//  Created by Chris Eadie on 11/12/2020.
//

import Foundation

struct UdacityClient {
    
    static func postRequestFor(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func getLocations(completion: @escaping (Bool, Error?) -> Void) {
        let url = OnTheMapAPI.Endpoints.getLocations.url
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Location.Response.self, from: data)
                let locations = decodedData.results
                Locations.list = locations
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        
        task.resume()
    }
    
    static func postLocation(location: OnTheMapAPI.LocationForPosting, completion: @escaping (Bool, Error?) -> Void) {
        let url = OnTheMapAPI.Endpoints.location.url
        
        var request = postRequestFor(url: url)
        request.httpBody = "{\"uniqueKey\": \"\(location.uniqueKey)\", \"firstName\": \"\(location.firstName)\", \"lastName\": \"\(location.lastName)\",\"mapString\": \"\(location.mapString)\", \"mediaURL\": \"\(location.mediaURL)\", \"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            do {
                let confirmation = try JSONDecoder().decode(Location.CreationResponse.self, from: data)
                if confirmation.createdAt.count > 0 {
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        
        task.resume()
    }
    
    static func postSession(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = OnTheMapAPI.Endpoints.session.url
        
        var request = postRequestFor(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error?.localizedDescription)
                }
                return
            }
            
            // Remove first 5 characters from data - Udacity security precautions
            let range = 5..<data.count
            let skimmedData = data.subdata(in: range)
            
            do {
                let response = try JSONDecoder().decode(Session.CreationResponse.self, from: skimmedData)
                let sessionId = response.session.id
                
                DispatchQueue.main.async {
                    OnTheMapAPI.Session.id = sessionId
                    completion(true, nil)
                }
            } catch {
                do {
                    print(String(decoding: skimmedData, as: UTF8.self))
                    let failureData = try JSONDecoder().decode(Failure.self, from: skimmedData)
                    DispatchQueue.main.async {
                        completion(false, failureData.error)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error.localizedDescription)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    static func deleteSession(completion: @escaping (Bool, Error?) -> Void) {
        let url = OnTheMapAPI.Endpoints.session.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            do {
                // Remove first 5 characters from data - Udacity security precautions
                let range = 5 ..< data.count
                let skimmedData = data.subdata(in: range)
                
                let response = try JSONDecoder().decode(Session.DeletionResponse.self, from: skimmedData)
                if response.session.id.count > 0 {
                    DispatchQueue.main.async {
                        OnTheMapAPI.Session.id = nil
                        completion(true, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
        
        task.resume()
    }
    
}
