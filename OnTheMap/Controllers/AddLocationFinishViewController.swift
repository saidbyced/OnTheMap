//
//  AddLocationFinishViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 21/12/2020.
//

import UIKit
import MapKit

class AddLocationFinishViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.addAnnotation(newLocation)
        mapView.setCenter(newLocation.coordinate, animated: true)
        addCancelButton()
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        if let location = Locations.toAdd {
            print(location)
            UdacityClient.postLocation(location: location, completion: handleAddingLocationResponse(success:errorMessage:))
        }
    }
    
    func handleAddingLocationResponse(success: Bool, errorMessage: String?) {
        if success {
            print("Location added")
            UdacityClient.getLocations { (success, error) in
                if success {
                    print("Got updated locations list")
                } else {
                    let errorMessage = errorMessage ?? "Unable to get student locations"
                    let ac = UIAlertController(title: "Location request failed", message: errorMessage, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                }
            }
            goBack()
        } else {
            let errorMessage = errorMessage ?? "Unable to create location"
            let ac = UIAlertController(title: "Location sending failed", message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
    }
    
}

extension AddLocationFinishViewController: UINavigationControllerDelegate {
    
    @objc func goBack() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func addCancelButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
    }
    
}


extension AddLocationFinishViewController: MKMapViewDelegate {
    
    var newLocation: MKAnnotation {
        let location = Locations.toAdd
        let latitude = CLLocationDegrees(location!.latitude)
        let longitude = CLLocationDegrees(location!.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location?.mapString
        annotation.subtitle = location?.mediaURL
        
        return annotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoReuseIdent = "pin"
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annoReuseIdent)
        annotationView.pinTintColor = UIColor(red: 2/256, green: 179/256, blue: 228/256, alpha: 1)
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
}
