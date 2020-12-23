//
//  Response.swift
//  OnTheMap
//
//  Created by Chris Eadie on 11/12/2020.
//

import Foundation

struct Location {

    struct Response: Codable {
        let results: [Result]
    }

    struct Result: Codable {
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

}

struct Session {

    struct CreationResponse: Codable {
        let account: AccountDetail
        let session: Detail
    }

    struct DeletionResponse: Codable {
        let session: Detail
    }

    struct AccountDetail: Codable {
        let registered: Bool
        let key: String
    }

    struct Detail: Codable {
        let id: String
        let expiration: String
    }

}
