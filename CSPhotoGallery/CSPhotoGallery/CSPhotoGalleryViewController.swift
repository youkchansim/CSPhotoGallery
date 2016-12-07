//
//  CSPhotoGalleryViewController.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 7..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit
import Photos

class CSPhotoGalleryViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var galleryTypeBtn: UIButton!
    @IBOutlet weak var galleryTypeArrow: UIImageView!
    
    @IBOutlet weak var checkCount: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func galleryTypeBtnAction(_ sender: Any) {
    }
    
    @IBAction func checkBtnAction(_ sender: Any) {
    }
    
    var CHECK_MAX_COUNT = 20
    var thumbnailSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension CSPhotoGalleryViewController {
    fileprivate func setViewController() {
        setData()
        setView()
    }
    
    private func setData() {
        let scale = UIScreen.main.scale
        let cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
    }
    
    private func setView() {
        
    }
}

//  MARK:- UICollectionView DataSource
extension CSPhotoGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoManager.sharedInstance.getAssetCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CSPhotoGalleryCollectionViewCell
        cell.representedAssetIdentifier = PhotoManager.sharedInstance.getLocalIdentifier(at: indexPath)
        cell.setPlaceHolderImage(image: nil)
        
        PhotoManager.sharedInstance.setThumbnailImage(at: indexPath, thumbnailSize: thumbnailSize) { image in
            if cell.representedAssetIdentifier == PhotoManager.sharedInstance.getLocalIdentifier(at: indexPath) {
                cell.setImage(image: image)
            }
        }
        
        return cell
    }
}

//  MARK:- UICollectionView Delegate
extension CSPhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 3) / 4
        return CGSize(width: size, height: size)
    }
}
