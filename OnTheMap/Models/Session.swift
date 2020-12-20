//
//  Session.swift
//  OnTheMap
//
//  Created by Chris Eadie on 17/12/2020.
//

import Foundation

struct Session {
    static var id = String()
    static var loggedIn: Bool {
        return id.count > 0
    }
}
