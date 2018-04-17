//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Kuei-Jung Hu on 13/04/2018.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var detailMeme: Meme!

    @IBOutlet weak var memeDetialImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.memeDetialImageView.image = detailMeme.memedImage
        self.memeDetialImageView.contentMode = .scaleAspectFit
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editAction))
    }
    
//    @objc func editAction() {
//        let memeEditorVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
//        memeEditorVC.fromSentMemes = true
//        memeEditorVC.meme = detailMeme
//        self.present(memeEditorVC, animated: true, completion: nil)
//    }
}
