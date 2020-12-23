//
//  LocationMapViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 16/12/2020.
//
import UIKit
import MapKit

class LocationMapViewController: UIViewController {
    
    var loggedIn = false
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        setUpNavBar()
        
        mapView.delegate = self
        getLocations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpNavBar()
        updateLocations()
    }
    
    func getLocations() {
        if Locations.list.count == 0 {
            UdacityClient.getLocations(completion: handleLocationsResponse(success:error:))
        } else {
            updateLocations()
        }
    }
    
    func logOut() {
        UdacityClient.deleteSession(completion: handleLogOutResponse(success:error:))
    }
    
    func handleLocationsResponse(success: Bool, error: Error?) {
        if success {
            updateLocations()
        } else {
            // FIXME: Handle no locations received
            print(error?.localizedDescription ?? "Error: no locations")
        }
    }
    
    func handleLogOutResponse(success: Bool, error: Error?) {
        if success {
            print("Logged out")
            viewDidAppear(true)
        }
    }
    
}

extension LocationMapViewController: UINavigationControllerDelegate {
    
    func setUpNavBar() {
        loggedIn = OnTheMapAPI.Session.id != nil
        let logInOutButtonTitle = loggedIn ? "Log out" : "Log in"
        
        let logInOutButton = UIBarButtonItem(title: logInOutButtonTitle, style: .plain, target: self, action: #selector(goToLogIn))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
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
    
    @objc func goToAddLocation() {
        performSegue(withIdentifier: "addLocation", sender: self)
    }
    
}

extension LocationMapViewController: MKMapViewDelegate {
    
    func addAnnotations(limit: Int) {
        guard Locations.list.count > 0 else { return }
        
        for location in Locations.list[0...(limit - 1)] {
            annotations.append(annotationFor(location))
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func annotationFor(_ location: Location.Result) -> MKPointAnnotation {
        let latitude = CLLocationDegrees(location.latitude)
        let longitude = CLLocationDegrees(location.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let name = "\(location.firstName) \(location.lastName)"
        let mediaURL = location.mediaURL
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        annotation.subtitle = mediaURL
        
        return annotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoReuseIdent = "pin"
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annoReuseIdent)
        annotationView.pinTintColor = UIColor(red: 2/256, green: 179/256, blue: 228/256, alpha: 1)
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    func updateLocations() {
        if mapView.annotations.count > 0 {
            self.mapView.removeAnnotations(mapView.annotations)
        }
        self.addAnnotations(limit: 100)
    }
    
}
