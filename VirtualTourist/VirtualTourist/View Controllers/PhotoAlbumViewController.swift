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
    @IBOutlet weak var bottomButton: UIButton!
    
    var loadedPage = 1
    var selectedPin: Pin!
    var photos: [Photo] = []
    var selectedPhotoIndexPathToDelete: IndexPath? = nil {
        didSet {
            if selectedPhotoIndexPathToDelete != nil {
                bottomButton.setTitle("Remove", for: .normal)
            } else {
                bottomButton.setTitle("New Collection", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout

        mapView.addAnnotationToMap(coordinate: CLLocationCoordinate2D(latitude: selectedPin.lat, longitude: selectedPin.lon))
        
        refreshloadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func bottomButtonAction(_ sender: Any) {
        if selectedPhotoIndexPathToDelete != nil {
           CoreDataController.shared.deletePhoto(photo: photos[selectedPhotoIndexPathToDelete!.row]) {
                self.selectedPhotoIndexPathToDelete = nil
                self.refreshloadPhotos()
            }
        } else {
            CoreDataController.shared.deletePhotos(pin: selectedPin) {
                self.photos.removeAll()
                self.collectionView.reloadData()
                self.getPhotosFromFlicker()
            }
        }
    }
    
    func getPhotosFromFlicker() {
        let coord = CLLocationCoordinate2D(latitude: selectedPin.lat, longitude: selectedPin.lon)
        FlickerClient().getPhotos(coord: coord, page: loadedPage) { (images, pages, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.loadedPage = self.getRamdonPage(totalPages: pages!)
            CoreDataController.shared.addPhotos(images: images!, pin: self.selectedPin) { photos in
                self.photos = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getRamdonPage(totalPages: Int) -> Int {
        return Int.random(in: 1...totalPages)
    }
    
    func refreshloadPhotos() {
        photos = CoreDataController.shared.loadPhotos(pin: selectedPin)
        if photos.count == 0 {
            getPhotosFromFlicker()
        } else {
            collectionView.reloadData()
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
        cell.contentView.alpha = indexPath == selectedPhotoIndexPathToDelete ? 0.5 : 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedPhotoIndexPathToDelete == indexPath {
            selectedPhotoIndexPathToDelete = nil
        } else {
            selectedPhotoIndexPathToDelete = indexPath
        }
        collectionView.reloadData()
    }

}
