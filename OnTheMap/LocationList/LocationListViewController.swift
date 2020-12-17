//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 15/12/2020.
//

import UIKit

class LocationListViewController: UITableViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: nil),
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
        ]
        
        getLocations()
    }
    
    func getLocations() {
        if LocationList.count == 0 {
            OnTheMapAPI.getLocations(completion: handleLocationsResponse(locations:error:))
        }
    }
    
    func handleLocationsResponse(locations: [Location]?, error: Error?) {
        if let locations = locations {
            LocationList.locations = locations
            tableView.reloadData()
        } else {
            // FIXME: Handle no locations received
            print(error?.localizedDescription ?? "Error: no locations")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = LocationList.location(indexPath.row)
        let name = "\(location.firstName.capitalized) \(location.lastName.capitalized)"
        let url = location.mediaURL
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = url
        
        return cell
    }
}
