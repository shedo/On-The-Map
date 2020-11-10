//
//  ConfirmLocationViewController.swift
//  On the Map
//
//  Created by Ivan Zandonà on 09/11/2020.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var newLocation: NewLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        showDataInMap()
    }
    
    func showDataInMap(){
        var annotations = [MKPointAnnotation]()
        let coordinate = CLLocationCoordinate2D(latitude: self.newLocation.latitude ?? 0.0, longitude: self.newLocation.longitude ?? 0.0)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = newLocation.locationText ?? ""
        annotations.append(annotation)
        
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    @IBAction func addLocation(_ sender: Any) {
        Client.addLocation(locationData: self.newLocation, completion: addLocationHandler(success:error:))
    }
    
    func addLocationHandler(success: Bool, error: Error?){
        if success {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            DispatchQueue.main.async {
                self.showErrorAlertDialog(title: "Error", message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func showErrorAlertDialog(title:String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
