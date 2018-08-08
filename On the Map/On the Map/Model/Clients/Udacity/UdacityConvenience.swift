//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/24.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import UIKit

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    func displayAlert(_ controller: UIViewController, title: String, message: String) {
        let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) { action in
            uiAlertController.dismiss(animated: true, completion: nil)
        }
        uiAlertController.addAction(dismissAction)
        controller.present(uiAlertController, animated: true, completion: nil)
    }
    
    func displayAlertForOverwrite(_ controller: UIViewController, title: String, message: String) {
        let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) {
            action in self.presentAddLocation(controller)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            action in uiAlertController.dismiss(animated: true, completion: nil)
        }
        
        uiAlertController.addAction(overwriteAction)
        uiAlertController.addAction(cancelAction)
        
        controller.present(uiAlertController, animated: true, completion: nil)
    }
    
    func checkURL(_ url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func presentAddLocation(_ controller: UIViewController) {
        controller.performSegue(withIdentifier: "AddLocationSegue", sender: controller)
    }
    
    func addLocation(_ controller: UIViewController) {
        if UdacityClient.sharedInstance.showOverwrite {
            UdacityClient.sharedInstance.displayAlertForOverwrite(controller, title: "", message: UdacityClient.sharedInstance.substituteKeyInMethod(ErrorMessage.OverwriteMessage, key: "userName", value: "\(UdacityClient.sharedInstance.userFirstName ) \(UdacityClient.sharedInstance.userLastName )")!)
        } else {
            UdacityClient.sharedInstance.presentAddLocation(controller)
        }
    }
}

struct ErrorMessage {
    static let EmptyEmailOrPassword = "Empty Email or Password."
    static let InvalidEmailOrPassword = "Invalid Email or Password."
    static let NoNetwork = "The Internet connection appears to be offine."
    static let InvalidLinkTitle = "Invalid Link"
    static let InvalidLink = "Include HTTP(S)://"
    static let OverwriteMessage = "User \"{userName}\" Has Already Posted a Student Location. Would You Like to Overwrite Their Location?"
    static let LocationNotFound = "Location Not Found"
    static let EnterLocation = "Must Enter a Location."
    static let EnterWebsite = "Must Enter a Website."
    static let InvalidGeocode = "Could Not Geocode the String"
    static let UpdateLocationError = "Failed to Update Location."
    static let UnableToLogout = "Unable to Logout"
    static let CheckNetworkOrContactKuei = "Please Check your network connection or contact Kuei"
}
