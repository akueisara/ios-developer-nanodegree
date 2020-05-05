//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import MobileCoreServices

// MARK: Regift constants
let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // 0 means loop forever

// MARK: - UIViewController (Record)

extension UIViewController {
    
    @IBAction func presentVideoOptions() {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            launchPhotoLibrary()
        } else {
            let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            let recordView = UIAlertAction(title: "Record a Video", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self.launchVideoCamera()
            })
            
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                self.launchPhotoLibrary()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            newGifActionSheet.addAction(recordView)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            present(newGifActionSheet, animated: true, completion: nil)
            let pinkColor = UIColor(red: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
        }
    }
    
    // MARK: Select Video
    
    private func launchVideoCamera() {
        present(pickerControllerWithSource(source: UIImagePickerController.SourceType.camera), animated: true, completion: nil)
    }
    
    private func launchPhotoLibrary() {
        present(pickerControllerWithSource(source: UIImagePickerController.SourceType.photoLibrary), animated: true, completion: nil)
    }
    
    private func pickerControllerWithSource(source: UIImagePickerController.SourceType) -> UIImagePickerController {
        
        // create imagePicker
        let picker = UIImagePickerController()
               
        // set properties: sourcetype, mediatype, allowsEditing, delegate
        picker.sourceType = source
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = false
        picker.delegate = self

        return picker
    }
}

// MARK: - UIViewController: UINavigationControllerDelegate

extension UIViewController: UINavigationControllerDelegate {}

// MARK: - UIViewController: UIImagePickerControllerDelegate

extension UIViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as! String
               // Handle a movie capture
               if (mediaType == kUTTypeMovie as String) {
                let videoURL = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as! URL
                    
                   dismiss(animated: true, completion: nil)
                   // Get start and end points from trimmed video
                   // UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, nil, nil, nil)
                   convertVideoToGIF(videoURL: videoURL)
               }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // GIF conversion methods
    private func convertVideoToGIF(videoURL: URL) {
        let regift = Regift(sourceFileURL: videoURL as URL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let gifURL = regift.createGif()
        let gif = Gif(url:gifURL!, videoURL: videoURL, caption: nil)
        
        displayGif(gif: gif)
    }
    
    private func displayGif(gif: Gif) {
        let gitEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gitEditorVC.gif = gif
        navigationController?.pushViewController(gitEditorVC, animated: true)
    }
    
}
