//
//  FinishAddLocationViewController.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/5/15.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import UIKit
import MapKit

class FinishAddLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var location: String = ""
    var pointAnnotation = MKPointAnnotation()
    var latitude: Double = 0.00
    var longitude: Double = 0.00
    var mediaURL: String = ""

    // MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.centerCoordinate = pointAnnotation.coordinate
        mapView.addAnnotation(pointAnnotation)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    // MARK: actions
    
    @IBAction func finish(_ sender: Any) {
        activityIndicator.startAnimating()
        let userData = StudentInformation(createdAt: "", firstName: UdacityClient.sharedInstance.userFirstName, lastName: UdacityClient.sharedInstance.userLastName, latitude: latitude, longitude: longitude, mapString: "", mediaURL: mediaURL, objectId: UdacityClient.sharedInstance.userObjectId, uniqueKey: UdacityClient.sharedInstance.userUniqueKey, updatedAt: "")
        if UdacityClient.sharedInstance.showOverwrite {
            UdacityClient.sharedInstance.updateUserData(student: userData, location: location) { success, error in
                DispatchQueue.main.async{
                    self.actionForMainQueue(success, error)
                }
            }
        } else {
            UdacityClient.sharedInstance.postUserData(student: userData, location: location) { success, error in
                DispatchQueue.main.async{
                    self.actionForMainQueue(success, error)
                }
            }
        }
    }
    
    private func actionForMainQueue(_ success: Bool, _ error: NSError? = nil) {
        activityIndicator.stopAnimating()
        if success {
            UdacityClient.sharedInstance.showOverwrite = true
            UdacityClient.sharedInstance.loadViews = true
            UdacityClient.sharedInstance.loadMapView = false
            UdacityClient.sharedInstance.loadTableView = false
            dismiss(animated: true, completion: nil)
        } else {
            if(error?.code == 1) {
                UdacityClient.sharedInstance.displayAlert(self, title: "", message: error?.localizedDescription ?? "Unknown error")
            } else {
                UdacityClient.sharedInstance.displayAlert(self, title: ErrorMessage.LocationNotFound, message: ErrorMessage.UpdateLocationError)
            }
        }
    }
}
