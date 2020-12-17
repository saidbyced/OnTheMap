//
//  Response.swift
//  OnTheMap
//
//  Created by Chris Eadie on 11/12/2020.
//

import Foundation

struct LocationsResponse: Codable {
    let results: [Location]
}

struct Location: Codable {
    let firstName, lastName: String
    let longitude, latitude: Double
    let mapString, mediaURL, uniqueKey, objectId, createdAt, updatedAt: String
}

struct CreationResponse: Codable {
    let createdAt, objectId: String
}

struct UpdateResponse: Codable {
    let updatedAt: String
}
