//
//  PostStudentLocationViewController.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/5/14.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    // MARK: Properties

    var latitude: Double = 0.00
    var longitude: Double = 0.00
    
    // MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = self
        websiteTextField.delegate = self
        
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Actions

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationPressed(_ sender: Any) {
        userDidTapView(self)
        
        if locationTextField.text!.isEmpty  {
            UdacityClient.sharedInstance.displayAlert(self, title: ErrorMessage.LocationNotFound, message: ErrorMessage.EnterLocation)
        } else if websiteTextField.text!.isEmpty {
            UdacityClient.sharedInstance.displayAlert(self, title: ErrorMessage.LocationNotFound, message: ErrorMessage.EnterWebsite)
        } else if !UdacityClient.sharedInstance.checkURL(websiteTextField.text!) {
            UdacityClient.sharedInstance.displayAlert(self, title: ErrorMessage.LocationNotFound, message: ErrorMessage.InvalidLinkTitle + ". " + ErrorMessage.InvalidLink)
        } else {
            let localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = locationTextField.text
            let localSearch = MKLocalSearch(request: localSearchRequest)
            activityIndicator.startAnimating()
            localSearch.start { (localSearchResponse, error) -> Void in
                if localSearchResponse == nil{
                    self.activityIndicator.stopAnimating()
                    UdacityClient.sharedInstance.displayAlert(self, title: ErrorMessage.LocationNotFound, message: ErrorMessage.InvalidGeocode)
                    return
                }
                
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = self.locationTextField.text!
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
                
                self.latitude = localSearchResponse!.boundingRegion.center.latitude
                self.longitude = localSearchResponse!.boundingRegion.center.longitude
                
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as! FinishAddLocationViewController
                controller.location = self.locationTextField.text!
                controller.mediaURL = self.websiteTextField.text!
                controller.pointAnnotation = pointAnnotation
                controller.latitude = self.latitude
                controller.longitude = self.longitude
                self.navigationController?.pushViewController(controller, animated: true)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - AddLocationViewController: UITextFieldDelegate

extension AddLocationViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardDidShow(_ notification: Notification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(locationTextField)
        resignIfFirstResponder(websiteTextField)
    }
}

// MARK: - AddLocationViewController (Notifications)

private extension AddLocationViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
