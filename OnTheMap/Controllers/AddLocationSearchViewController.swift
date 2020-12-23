//
//  AddLocationSearchViewController.swift
//  OnTheMap
//
//  Created by Chris Eadie on 21/12/2020.
//

import UIKit
import MapKit
    
class AddLocationSearchViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        if let location = locationTextField.text, let link = linkTextField.text {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = location
            
            let search = MKLocalSearch(request: searchRequest)
            
            search.start { response, error in
                guard let response = response else {
                    print("Error: \(error?.localizedDescription ?? "unknown")")
                    return
                }
                
                guard let coordinate = response.mapItems[0].placemark.location?.coordinate else {
                    return
                }
                
                let uniqueKey = Int.random(in: 0..<999999999)
                
                Locations.toAdd = OnTheMapAPI.LocationForPosting(
                    uniqueKey: "\(uniqueKey)",
                    firstName: "John",
                    lastName: "Smith",
                    mapString: location,
                    mediaURL: link,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "finishAddLocation", sender: self)
                }
            }
        }
    }
    
}
