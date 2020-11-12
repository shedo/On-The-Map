//
//  ConfirmLocationViewController.swift
//  On the Map
//
//  Created by Ivan Zandonà on 09/11/2020.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {
    
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
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func addLocation(_ sender: Any) {
        showLoader(show: true)
        Client.addLocation(locationData: self.newLocation, completion: addLocationHandler(success:error:))
    }
    
    func addLocationHandler(success: Bool, error: Error?){
        self.showLoader(show: false)
        if success {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.showAlertDialog(title: "Error", message: error?.localizedDescription ?? "")
        }
        _ = navigationController?.popToRootViewController(animated: true)
    }
}

extension ConfirmLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
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
                if let urlToOpen = URL(string: toOpen) {
                    UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
                } else {
                    self.showAlertDialog(title: "Error", message: "No valid url to open")
                }
            }
        }
    }
}
