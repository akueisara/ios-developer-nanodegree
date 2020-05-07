//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/6.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController {
    
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    var gif: Gif? 

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        gifImageView.image = gif?.gifImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func presentPreview(sender: AnyObject) {
        let previewVC = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        gif?.caption = captionTextField.text
        let regift = Regift(sourceFileURL: gif!.videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let cationFont = captionTextField.font
        let gifURL = regift.createGif(captionTextField.text, font: cationFont)!
        let newGif = Gif(url: gifURL, videoURL: gif!.videoURL, caption: captionTextField.text)
        previewVC.gif = newGif
        previewVC.delegate = navigationController?.viewControllers.first as! SavedGifsViewController
        navigationController?.pushViewController(previewVC, animated: true)
    }
}

// Methods to adjust the keyboard
extension GifEditorViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if (self.view.frame.origin.y < 0) {
            view.frame.origin.y += getKeyboardHeight(notification: notification)
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

extension GifEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
