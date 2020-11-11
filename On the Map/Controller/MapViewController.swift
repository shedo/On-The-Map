//
//  MapViewController.swift
//  On the Map
//
//  Created by Ivan Zandonà on 07/11/2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader(show: true)
        Client.getStudentLocations(completion: { (studentInformation, error) in
            self.showLoader(show: false)
            if error == nil {
                StudentLocationModel.locations = studentInformation
                self.loadAnnotation()
            } else {
                self.showErrorAlertDialog(title: "Error", message: error?.localizedDescription ?? "")
            }
        })
    }
    
    func loadAnnotation() {
        var annotations = [MKPointAnnotation]()
        
        for location in StudentLocationModel.locations {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
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
                    self.showErrorAlertDialog(title: "Error", message: "No valid url to open")
                }
            }
        }
    }
}
