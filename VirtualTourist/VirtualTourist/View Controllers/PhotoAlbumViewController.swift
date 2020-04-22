//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Kuei-Jung Hu on 2020/4/22.
//  Copyright © 2020 Kuei-Jung Hu. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedPin: Pin!
    var photos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout

        mapView.addAnnotationToMap(coordinate: CLLocationCoordinate2D(latitude: selectedPin.lat, longitude: selectedPin.lon))
        
        photos = CoreDataController.shared.loadPhotos(pin: selectedPin)
        if photos.count == 0 {
            getPhotosFromFlicker()
        }
    }
    

    func getPhotosFromFlicker() {
        let coord = CLLocationCoordinate2D(latitude: selectedPin.lat, longitude: selectedPin.lon)
        FlickerClient().getPhotos(coord: coord, page: 1) { (images, pages, error) in
            if let images = images {
                for image in images {
                    CoreDataController.shared.addPhoto(id: image.id, imageURL: image.photoImageURL(), imageData: nil, pin: self.selectedPin) { photo in
                        self.photos.append(photo)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.setupPhoto(photos[indexPath.row])
        return cell
    }
}
