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
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = Locations.list[indexPath.row].mediaURL
        
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            let ac = UIAlertController(title: "Cannot open link", message: "URL provided is not a valid website", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    func getLocations() {
        if Locations.list.count == 0 {
            UdacityClient.getLocations(completion: handleLocationsResponse(success:errorMessage:))
        }
    }
    
    func logOut() {
        UdacityClient.deleteSession(completion: handleLogOutResponse(success:error:))
    }
    
    func handleLocationsResponse(success: Bool, errorMessage: String?) {
        if success {
            tableView.reloadData()
        } else {
            let errorMessage = errorMessage ?? "Unable to get student locations"
            let ac = UIAlertController(title: "Location request failed", message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
            return
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
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshLocations))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddLocation))
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
    
    @objc func refreshLocations() {
        UdacityClient.getLocations(completion: handleLocationsResponse(success:errorMessage:))
    }
    
    @objc func goToAddLocation() {
        performSegue(withIdentifier: "addLocation", sender: self)
    }
    
}
