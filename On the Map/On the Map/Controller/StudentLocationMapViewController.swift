//
//  MapViewController.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/25.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationMapViewController: UIViewController, MKMapViewDelegate {

    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        loadMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadMapView() {
        UdacityClient.sharedInstance().getStudentLocations(){(students, error) in
            if let students = students {
                DispatchQueue.main.async {
                    print("Successfully Getting Data!")
                    self.setUpLocationData(students)
                }
            } else {
                UdacityClient.sharedInstance().displayAlert(self, title: "", message: "Error Getting Data!")
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    
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
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!, UdacityClient.sharedInstance().checkURL(toOpen) {
                app.open(URL(string: toOpen)!)
            } else {
                UdacityClient.sharedInstance().displayAlert(self, title: "", message: ErrorMessage.InvalidLinkTitle)
            }
        }
    }
    
    // MARK: - Set UpData
    
    func setUpLocationData(_ studentLocations: [UdacityStudent]) {
        self.mapView.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        
        let locations = studentLocations

        for dictionary in locations {
            
            if let lat = dictionary.latitude,  let long = dictionary.longitude{
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                annotations.append(annotation)
            }
        }

        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: Logout
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion:{
            UdacityClient.sharedInstance().logout()
        })
    }
}
