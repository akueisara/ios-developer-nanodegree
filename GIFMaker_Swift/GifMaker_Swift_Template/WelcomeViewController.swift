//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/6.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let proofOfConceptGif = UIImage.gif(name: "hotlineBling")
        gifImageView.image = proofOfConceptGif
        
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
    }

}
