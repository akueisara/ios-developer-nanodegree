//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Kuei-Jung Hu on 2020/4/22.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    func setupPhoto(_ photo: Photo) {
        if photo.imageData == nil {
            activityIndicator.startAnimating()
            downloadImage(photo)
        } else {
            displayImage(data: photo.imageData!)
        }
    }
    
    func downloadImage(_ photo: Photo) {
        FlickerClient().getPhotoImageData(photo: photo) { (data, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            CoreDataController.shared.saveImageDataToPhoto(photo: photo, imageData: data!) {
                DispatchQueue.main.async {
                    self.displayImage(data: data!)
                }
            }
        }
    }
    
    private func displayImage(data: Data) {
        imageView.image = UIImage(data: data)
        activityIndicator.stopAnimating()
    }
}
