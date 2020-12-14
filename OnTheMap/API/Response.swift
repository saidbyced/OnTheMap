//
//  Response.swift
//  OnTheMap
//
//  Created by Chris Eadie on 11/12/2020.
//

import Foundation

struct StudentLocationsResponse: Codable {
    let results: [LocationResponse]
}

struct LocationResponse: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: Int
    let updatedAt: String
}

struct CreationResponse: Codable {
    let createdAt: String
    let objectId: String
}

struct UpdateResponse: Codable {
    let updatedAt: String
}
