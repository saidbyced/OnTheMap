//
//  Location.swift
//  OnTheMap
//
//  Created by Chris Eadie on 17/12/2020.
//

import Foundation

struct Location {
    static var list = [Result]()
    static var count: Int {
        return list.count
    }
    
    static func forIndex(_ index: Int) -> Result {
        return list[index]
    }
    
    static var toAdd: OnTheMapAPI.StudentLocationForPosting?
}
