//
//  MapViewController.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/25.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class StudentLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        loadMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(UdacityClient.sharedInstance().loadViews) {
            loadMapView()
            if(UdacityClient.sharedInstance().loadTableView && UdacityClient.sharedInstance().loadMapView) {
                UdacityClient.sharedInstance().loadViews = false
            }
        }
    }
    
    func loadMapView() {
        UdacityClient.sharedInstance().loadMapView = true
        activityIndicator.startAnimating()
        UdacityClient.sharedInstance().getStudentLocations(){(students, error) in
            if let students = students {
                DispatchQueue.main.async {
                    self.setupLocationData(students)
                    self.activityIndicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
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
    
    // MARK: - Setup Data
    
    func setupLocationData(_ studentLocations: [StudentInformation]) {
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
                annotation.title = "\(first ?? StudentInformation.FristNameDefault) \(last ?? StudentInformation.LastNameDefault)"
                annotation.subtitle = mediaURL ?? StudentInformation.MediaURLDefault
                
                annotations.append(annotation)
            }
        }

        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: Actions
    
    @IBAction func refresh(_ sender: Any) {
        loadMapView()
    }

    @IBAction func addLocation(_ sender: Any) {
        UdacityClient.sharedInstance().addLocation(self)
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion:{
            UdacityClient.sharedInstance().logout()
        })
    }
}
