//
//  GifCell.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/7.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func configureForGif(_ gif: Gif) {
        gifImageView.image = gif.gifImage
    }
}
