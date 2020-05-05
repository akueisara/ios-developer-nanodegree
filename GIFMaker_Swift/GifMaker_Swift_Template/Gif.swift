//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/6.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif {
    let url: URL
    let videoURL: URL
    var caption: String?
    let gifImage: UIImage?
    var gifData: Data?

    init(url:URL, videoURL: URL, caption: String?) {
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString)!
        self.gifData = nil
    }

//    init(name: String){
//        self.gifImage = UIImage.gif(name: name)
//    }
}
