//
//  LocationMapViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 16/12/2020.
//
import UIKit
import MapKit

class LocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        getInitialLocation()
        
        mapView.delegate = self
    }
    
}

extension LocationMapViewController: CLLocationManagerDelegate {

    func getInitialLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        mapView.centerCoordinate = location
    }
    
}
