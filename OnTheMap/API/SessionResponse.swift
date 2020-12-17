//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Chris Eadie on 17/12/2020.
//

import Foundation

struct SessionResponse: Codable {
    let account: AccountDetail
    let session: SessionDetail
}

struct AccountDetail: Codable {
    let registered: Bool
    let key: String
}

struct SessionDetail: Codable {
    let id: String
    let expiration: String
}
