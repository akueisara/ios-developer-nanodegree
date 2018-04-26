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
    
    func checkURL(_ url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

struct ErrorMessage {
    static let EmptyEmailOrPassword = "Empty Email or Password."
    static let InvalidEmailOrPassword = "Invalid Email or Password."
    static let NoNetwork = "The Internet connection appears to be offine."
    static let InvalidLinkTitle = "Invalid Link"
    static let InvalidLink = "Include HTTP(S)://"
}
