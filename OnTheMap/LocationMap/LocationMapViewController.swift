//
//  LocationMapViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 16/12/2020.
//
import UIKit
import MapKit

class LocationMapViewController: UIViewController {
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocations()
        
        mapView.delegate = self
    }
    
    func getLocations() {
        if LocationList.count == 0 {
            OnTheMapAPI.getLocations(completion: handleLocationsResponse(locations:error:))
        } else {
            self.addAnnotations(limit: 50)
        }
    }
    
    func handleLocationsResponse(locations: [Location]?, error: Error?) {
        if let locations = locations {
            LocationList.locations = locations
            self.addAnnotations(limit: 50)
        } else {
            // FIXME: Handle no locations received
            print(error?.localizedDescription ?? "Error: no locations")
        }
    }
    
}

extension LocationMapViewController: MKMapViewDelegate {
    
    func addAnnotations(limit: Int) {
        guard LocationList.count > 0 else { return }
        
        for location in LocationList.locations[0...(limit - 1)] {
            annotations.append(annotationFor(location))
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    func annotationFor(_ location: Location) -> MKPointAnnotation {
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
    
}
