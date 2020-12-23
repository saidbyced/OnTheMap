//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 15/12/2020.
//

import UIKit

class LocationListViewController: UITableViewController {
    
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        setUpNavBar()
        
        getLocations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpNavBar()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Locations.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = Locations.list[indexPath.row]
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
        if Locations.list.count == 0 {
            UdacityClient.getLocations(completion: handleLocationsResponse(success:error:))
        }
    }
    
    func logOut() {
        UdacityClient.deleteSession(completion: handleLogOutResponse(success:error:))
    }
    
    func handleLocationsResponse(success: Bool, error: Error?) {
        if success {
            tableView.reloadData()
        } else {
            // FIXME: Handle no locations received
            print(error?.localizedDescription ?? "Error: no locations")
        }
    }
    
    func handleLogOutResponse(success: Bool, error: Error?) {
        if success {
            print("Logged out")
            viewDidAppear(false)
        }
    }
    
}

extension LocationListViewController: UINavigationControllerDelegate {
    
    func setUpNavBar() {
        loggedIn = OnTheMapAPI.Session.id != nil
        let logInOutButtonTitle = loggedIn ? "Log out" : "Log in"
        
        let logInOutButton = UIBarButtonItem(title: logInOutButtonTitle, style: .plain, target: self, action: #selector(goToLogIn))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.isEnabled = loggedIn
        
        navigationItem.leftBarButtonItem = logInOutButton
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
    }
    
    @objc func goToLogIn() {
        if loggedIn {
            logOut()
        } else {
            performSegue(withIdentifier: "logIn", sender: self)
        }
    }
    
}
