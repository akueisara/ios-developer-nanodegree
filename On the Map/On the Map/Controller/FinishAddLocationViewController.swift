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
        
        self.mapView.delegate = self
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.centerCoordinate = pointAnnotation.coordinate
        self.mapView.addAnnotation(pointAnnotation)
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
        let userData = StudentInformation(dictionary: [UdacityClient.JSONResponseKeys.StudentFirstName : UdacityClient.sharedInstance().userFirstName as AnyObject, UdacityClient.JSONResponseKeys.StudentLastName: UdacityClient.sharedInstance().userLastName as AnyObject, UdacityClient.JSONResponseKeys.StudentMediaURL: mediaURL as AnyObject, UdacityClient.JSONResponseKeys.StudentLatitude: latitude as AnyObject, UdacityClient.JSONResponseKeys.StudentLongitude: longitude as AnyObject, UdacityClient.JSONResponseKeys.StudentObjectId: UdacityClient.sharedInstance().userObjectId as AnyObject, UdacityClient.JSONResponseKeys.StudentUniqueKey: UdacityClient.sharedInstance().userUniqueKey as AnyObject])
        if UdacityClient.sharedInstance().showOverwrite {
            UdacityClient.sharedInstance().updateUserData(student: userData, location: location) { success, result in
                DispatchQueue.main.async{
                    self.actionForMainQueue(success)
                }
            }
        } else {
            UdacityClient.sharedInstance().postUserData(student: userData, location: location) { success, result in
                DispatchQueue.main.async{
                    self.actionForMainQueue(success)
                }
            }
        }
    }
    
    private func actionForMainQueue(_ success: Bool) {
        self.activityIndicator.stopAnimating()
        if success {
            UdacityClient.sharedInstance().showOverwrite = true
            self.appDelegate.loadViews = true
            self.appDelegate.loadMapView = false
            self.appDelegate.loadTableView = false
            self.dismiss(animated: true, completion: nil)
        } else {
            UdacityClient.sharedInstance().displayAlert(self, title: ErrorMessage.LocationNotFound, message: ErrorMessage.UpdateLocationError)
        }
    }
}
