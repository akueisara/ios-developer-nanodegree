//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/5.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

// MARK: Regift constants
let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // 0 means loop forever
let frameRate = 15

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
        picker.allowsEditing = true
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
            
            // Get start and end points from trimmed video
            let start: NSNumber? = info[UIImagePickerController.InfoKey(rawValue: "_UIImagePickerControllerVideoEditingStart")] as? NSNumber
            let end: NSNumber? = info[UIImagePickerController.InfoKey(rawValue: "_UIImagePickerControllerVideoEditingEnd")] as? NSNumber
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(value: (end!.floatValue) - (start.floatValue))
            } else {
                duration = nil
            }
            convertVideoToGIF(videoURL: videoURL, start: start, duration: duration)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // GIF conversion methods
    func cropVideoToSquare(videoURL: URL, start: NSNumber?, duration: NSNumber?) {

        // Initialize AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url:videoURL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]

        // Initialize video composition and set properties
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)

        // Initialize instruction and set time range
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))

        //Center the cropped video
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack:videoTrack)
        let firstTransform = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2.0)

        //Rotate 90 degrees to portrait
        let halfOfPi: CGFloat = CGFloat(Double.pi/2)
        let secondTransform = firstTransform.rotated(by: halfOfPi);
        let finalTransform = secondTransform;
        transformer.setTransform(finalTransform, at:CMTime.zero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]

        // Export the square video
        let exporter = AVAssetExportSession(asset:videoAsset, presetName:AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        let path = createPath()
        exporter.outputURL = URL(fileURLWithPath:path)
        exporter.outputFileType = AVFileType.mov

        exporter.exportAsynchronously {
            if let squareURL = exporter.outputURL {
                self.convertVideoToGIF(videoURL: squareURL, start: start, duration: duration)
            }
        }
    }
    
    private func createPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let manager = FileManager.default
        let outputURLString = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("output.mov").absoluteString
      
        if manager.fileExists(atPath: outputURLString) {
            do {
                try FileManager.default.removeItem(atPath: outputURLString)
            } catch {
                print("Error when removing output URL from File Manager")
            }
        }
       
        return outputURLString
    }
    
    private func convertVideoToGIF(videoURL: URL, start: NSNumber?, duration: NSNumber?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
        let regift: Regift

        if let start = start {
            // Trimmed
            regift = Regift(sourceFileURL: videoURL, startTime: start.floatValue, duration: duration!.floatValue, frameRate: frameRate, loopCount: loopCount)
        } else {
            // Untrimmed
            regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }

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
