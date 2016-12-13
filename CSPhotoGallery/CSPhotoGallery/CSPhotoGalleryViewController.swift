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

    @IBOutlet fileprivate weak var backBtn: UIButton!
    @IBOutlet fileprivate weak var galleryTypeBtn: UIButton!
    @IBOutlet fileprivate weak var galleryTypeArrow: UIImageView!
    @IBOutlet fileprivate weak var checkCount: UILabel!
    @IBOutlet fileprivate weak var checkBtn: UIButton!
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    fileprivate var assetCollectionViewController = CSPhotoGalleryAssetCollectionViewController.sharedInstance
    fileprivate var thumbnailSize: CGSize = CGSize.zero
    fileprivate var CSObservationContext = CSObservation()
    
    var delegate: CSPhotoGalleryDelegate?
    
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

//  MARK:- Actions
private extension CSPhotoGalleryViewController {
    @IBAction func galleryTypeBtnAction(_ sender: Any) {
        assetCollectionViewController.isHidden = !assetCollectionViewController.isHidden
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        delegate?.dismiss()
    }
    
    @IBAction func checkBtnAction(_ sender: Any) {
        delegate?.getAssets(assets: PhotoManager.sharedInstance.assets)
    }
}

fileprivate extension CSPhotoGalleryViewController {
    func setViewController() {
        setData()
        setView()
    }
    
    func setData() {
        PhotoManager.sharedInstance.initPhotoManager()
        setThumbnailSize()
    }
    
    func setThumbnailSize() {
        let scale = UIScreen.main.scale
        let cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        let size = min(cellSize.width, cellSize.height) * scale
        thumbnailSize = CGSize(width: size, height: size)
    }
    
    func setView() {
        addAssetCollectionView()
        addObserver()
    }
    
    func addAssetCollectionView() {
        assetCollectionViewController.view.frame = collectionView.frame
        assetCollectionViewController.viewHeight = collectionView.bounds.height
        assetCollectionViewController.view.frame.size.height = 0
        
        addChildViewController(assetCollectionViewController)
        view.addSubview(assetCollectionViewController.view)
        assetCollectionViewController.didMove(toParentViewController: self)
    }
    
    func addObserver() {
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
        //  Present photo viewer
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 2) / 3
        return CGSize(width: size, height: size)
    }
}
