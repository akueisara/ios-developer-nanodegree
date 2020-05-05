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
    
    // MARK: Select Video
    
    @IBAction func launchVideoCamera(sender: AnyObject) {
        
        // create imagePicker
        let recordVideoViewController = UIImagePickerController()
        
        // set properties: sourcetype, mediatype, allowsEditing, delegate
        recordVideoViewController.sourceType = UIImagePickerController.SourceType.camera
        recordVideoViewController.mediaTypes = [kUTTypeMovie as String]
        recordVideoViewController.allowsEditing = false
        recordVideoViewController.delegate = self
        
        // present controller
        present(recordVideoViewController, animated: true, completion: nil)
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
    func convertVideoToGIF(videoURL: URL) {
        let regift = Regift(sourceFileURL: videoURL as URL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        let gifURL = regift.createGif()
        let gif = Gif(url:gifURL!, videoURL: videoURL, caption: nil)
        
        displayGif(gif: gif)
    }
    
    func displayGif(gif: Gif) {
        let gitEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gitEditorVC.gif = gif
        navigationController?.pushViewController(gitEditorVC, animated: true)
    }
    
}
