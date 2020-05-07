//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/7.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController, PreviewViewControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIStackView!
    
    var savedGifs = [Gif]()
    let cellMargin: CGFloat = 12.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyView.isHidden = savedGifs.count != 0
        collectionView.reloadData()
    }
    
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        savedGifs.append(gif)
    }

}

// MARK: - CollectionView Delegate and Datasource Methods

extension SavedGifsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = savedGifs[indexPath.item]
        cell.configureForGif(gif)
        return cell
    }
    
}

// MARK: - UICollectionViewFlowLayout

extension SavedGifsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - cellMargin * 2.0)/2.0
        return CGSize(width: width, height: width)
    }
    
}
