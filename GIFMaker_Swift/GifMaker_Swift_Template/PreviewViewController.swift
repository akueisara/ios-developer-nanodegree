//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/6.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate: class {
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif)
}

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    var gif: Gif?
    weak var delegate: PreviewViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gifImageView.image = gif?.gifImage
    }
    
    @IBAction func shareGif(sender: AnyObject) {
        let url: URL = (self.gif?.url)!
        let animatedGIF = try? Data(contentsOf: url)
        let itemsToShare = [animatedGIF]

        let activityVC = UIActivityViewController(activityItems: itemsToShare as [Any], applicationActivities: nil)

        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }

        navigationController?.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func createAndSave(sender: AnyObject) {
        // Copy GIF data from temporary URL
        gif!.gifData = try? Data(contentsOf: gif!.url)
        
        delegate?.previewVC(preview: self, didSaveGif: gif!)

        navigationController?.popToRootViewController(animated: true)
    }
}
