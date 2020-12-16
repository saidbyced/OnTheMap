//
//  LocationListViewModel.swift
//  OnTheMap
//
//  Created by Chris Eadie on 16/12/2020.
//

import Foundation

struct LocationList {
    static var locations = [Location]()
    static var count: Int {
        return locations.count
    }
    
    static func location(_ index: Int) -> Location {
        return locations[index]
    }
}
