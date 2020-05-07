//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Kuei-Jung Hu on 2020/5/7.
//  Copyright © 2020 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIStackView!
    
    var savedGifs = [Gif]()
    let cellMargin: CGFloat = 12.0
    
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.appending("/savedGifs")
        return gifsPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWelcome()
        if let gifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifsFilePath) as? [Gif] {
            savedGifs = gifs
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyView.isHidden = savedGifs.count != 0
        collectionView.reloadData()
    }
    
    func showWelcome() {
        if UserDefaults.standard.bool(forKey: "WelcomeViewSeen") != true {
            let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = savedGifs[indexPath.item]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.gif = gif
        
        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(detailVC, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewFlowLayout

extension SavedGifsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - cellMargin * 2.0)/2.0
        return CGSize(width: width, height: width)
    }
    
}

// MARK: - PreviewViewControllerDelegate

extension SavedGifsViewController: PreviewViewControllerDelegate {
    
    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        savedGifs.append(gif)
        NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifsFilePath)
    }
    
}
