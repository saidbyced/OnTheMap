//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 15/12/2020.
//

import UIKit

class LocationListViewController: UITableViewController {
    
    var loggedIn: Bool { return Session.loggedIn }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        getLocations()
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
    
}

extension LocationListViewController: UINavigationControllerDelegate {
    
    func setUpNavBar() {
        navigationController?.delegate = self
        
        let logInOutButtonTitle = loggedIn ? "Log out" : "Log in"
        
        let logInOutButton = UIBarButtonItem(title: logInOutButtonTitle, style: .plain, target: self, action: #selector(goToLogIn))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.isEnabled = loggedIn
        
        navigationItem.leftBarButtonItem = logInOutButton
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }
    
    @objc func goToLogIn() {
        performSegue(withIdentifier: "logIn", sender: self)
    }
    
}
