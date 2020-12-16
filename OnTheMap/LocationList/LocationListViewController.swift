//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 15/12/2020.
//

import UIKit

class LocationListViewController: UITableViewController {
    
    var locations: [Location]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OnTheMapAPI.getLocations(completion: handleLocationsResponse(locations:error:))
    }
    
    func handleLocationsResponse(locations: [Location]?, error: Error?) {
        if let locations = locations {
            print(locations.count)
            self.locations = locations
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let location = locations?[indexPath.row] else {
            return UITableViewCell()
        }
        let name = "\(location.firstName.capitalized) \(location.lastName.capitalized)"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = name
        
        return cell
    }
}
