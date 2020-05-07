//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/6.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif: NSObject, NSCoding {
   
    let url: URL
    let videoURL: URL
    var caption: String?
    let gifImage: UIImage
    var gifData: Data?

    init(url:URL, videoURL: URL, caption: String?) {
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = UIImage.gif(url: url.absoluteString)!
        self.gifData = nil
    }

    required init?(coder decoder: NSCoder) {
        self.url = decoder.decodeObject(forKey: "url") as! URL
        self.videoURL = decoder.decodeObject(forKey: "videoURL") as! URL
        self.caption = decoder.decodeObject(forKey: "caption") as? String
        self.gifImage = decoder.decodeObject(forKey: "gifImage") as! UIImage
        self.gifData = decoder.decodeObject(forKey:"gifData") as? Data
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.url, forKey: "url")
        coder.encode(self.videoURL, forKey: "videoURL")
        coder.encode(self.caption, forKey: "caption")
        coder.encode(self.gifImage, forKey: "gifImage")
        coder.encode(self.gifData, forKey:"gifData")
    }
    
}
