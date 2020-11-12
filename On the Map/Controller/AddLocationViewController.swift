//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Ivan Zandonà on 09/11/2020.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var myLocationText: UITextField!
    @IBOutlet weak var myLinkToShare: UITextField!
    var newLocation: NewLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmLocation" {
            if let destinationVC = segue.destination as? ConfirmLocationViewController {
                destinationVC.newLocation = self.newLocation
            }
        }
    }
    
    @IBAction func findLocation(_ sender: Any) {
        if myLocationText.text == "" || myLinkToShare.text == "" {
            self.showAlertDialog(title: "Missing required fields", message: "You should not leave any field empty")
        }
        else{
            //forward written string geocode
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(myLocationText.text ?? "") { (placemarks, error) in
                if (placemarks?.count == 0 || error != nil){
                    DispatchQueue.main.async {
                        self.showAlertDialog(title: "No Address Found", message: "Please write a valid address")
                    }
                } else {
                    let topResult: CLPlacemark = (placemarks?[0])!
                    let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                    let latitude = (placemark.location?.coordinate.latitude)!
                    let longitude = (placemark.location?.coordinate.longitude)!
                    
                    self.newLocation = NewLocation(locationText: self.myLocationText.text ?? "", locationLink: self.myLinkToShare.text ?? "", latitude: latitude, longitude: longitude)
                    self.performSegue(withIdentifier: "confirmLocation", sender: nil)
                }
            }
        }
    }
}
