//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Kuei-Jung Hu on 30/03/2018.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
//    var meme: Meme?
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let memeFromDetail = meme as Meme! {
//            setupTextField(textField: topTextField, text: memeFromDetail.topText)
//            setupTextField(textField: bottomTextField, text: memeFromDetail.bottomText)
//            imageView.image = memeFromDetail.originalImage
//        } else {
            setupTextField(textField: topTextField, text: "TOP")
            setupTextField(textField: bottomTextField, text: "BOTTOM")
//        }
    }
    
    func setupTextField(textField: UITextField, text: String) {
        AppUtils.setupTextField(textField: textField, text: text, textSize: 40)
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if imageView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
       pickAnImageFromSource(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImageFromSource(sourceType: .camera)
    }
    
    func pickAnImageFromSource(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setupImageView(image: image)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setupImageView(image: UIImage) {
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFit
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ["TOP", "BOTTOM"].contains(textField.text!) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,  name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self,  name: .UIKeyboardWillHide, object: nil)
    }
    
    func save() {
        // Update the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array on the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setVisibilityForBars(isHidden: Bool) {
        toolBar.isHidden = isHidden
        navBar.isHidden = isHidden
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        setVisibilityForBars(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
       setVisibilityForBars(isHidden: false)
        
        return memedImage
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            activity, success, items, error in
            
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if(imageView.image != nil) {
            shareButton.isEnabled = false;
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            imageView.image = nil
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

