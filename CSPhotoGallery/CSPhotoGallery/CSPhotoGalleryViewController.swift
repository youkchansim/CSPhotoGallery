//
//  CSPhotoGalleryViewController.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 7..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

typealias CSObservation = UInt8

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
    
    fileprivate var thumbnailSize: CGSize = CGSize.zero
    
    fileprivate var CSObservationContext = CSObservation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewController()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CSObservationContext {
            let count = PhotoManager.sharedInstance.selectedItemCount
            setCheckCountLabel(count: count)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        PhotoManager.sharedInstance.removeObserver(self, forKeyPath: "selectedItemCount")
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
        let size = min(cellSize.width, cellSize.height) * scale
        thumbnailSize = CGSize(width: size, height: size)
    }
    
    private func setView() {
        addObserver()
    }
    
    private func addObserver() {
        PhotoManager.sharedInstance.addObserver(self, forKeyPath: "selectedItemCount", options: .new, context: &CSObservationContext)
    }
    
    func setCheckCountLabel(count: Int) {
        DispatchQueue.main.async {
            self.checkCount.text = "\(count)"
        }
    }
}

//  MARK:- UICollectionView DataSource
extension CSPhotoGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoManager.sharedInstance.assetsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CSPhotoGalleryCollectionViewCell
        cell.indexPath = indexPath
        cell.representedAssetIdentifier = PhotoManager.sharedInstance.getLocalIdentifier(at: indexPath)
        
        cell.setPlaceHolderImage(image: nil)
        cell.setButtonImage()
        
        PhotoManager.sharedInstance.setThumbnailImage(at: indexPath, thumbnailSize: thumbnailSize) { image in
            if cell.indexPath == indexPath {
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
        let size = (collectionView.bounds.width - 2) / 3
        return CGSize(width: size, height: size)
    }
}
