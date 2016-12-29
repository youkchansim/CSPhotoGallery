//
//  CSPhotoGalleryDetailViewController.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 7..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

class CSPhotoGalleryDetailViewController: UIViewController {
    static var instance: CSPhotoGalleryDetailViewController {
        let bundlePath = Bundle.main.path(forResource: "CSPhotoGallery", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)
        let storyBoard = UIStoryboard.init(name: "CSPhotoGallery", bundle: bundle)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! CSPhotoGalleryDetailViewController
    }

    @IBOutlet fileprivate weak var currentIndexLabel: UILabel? {
        didSet {
            updateCurrentIndexLabel()
        }
    }
    
    @IBOutlet fileprivate weak var currentCollectionCountLabel: UILabel? {
        didSet {
            updateCurrentCollectionAssetCount()
        }
    }
    
    @IBOutlet fileprivate weak var checkCountLabel: UILabel? {
        didSet {
            updateCurrentSelectedCount()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var checkBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton! {
        didSet {
            if let title = CSPhotoDesignManager.instance.photoDetailOKButtonTitle {
                okBtn.setTitle(title, for: .normal)
            }
        }
    }
    
    @IBOutlet fileprivate weak var backBtn: UIButton! {
        didSet {
            if let image = CSPhotoDesignManager.instance.photoDetailBackButtonImage {
                backBtn.setImage(image, for: .normal)
            }
        }
    }
    
    var delegate: CSPhotoGalleryDelegate?
    fileprivate var prevIndexPath: IndexPath?
    var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            if PhotoManager.sharedInstance.assetsCount > 0 {
                updateCurrentIndexLabel()
                updateCheckBtnUI()
            }
        }
    }
    
    var currentImage: UIImage?
    var checkImage: UIImage? = CSPhotoDesignManager.instance.photoDetailCheckImage ?? UIImage(named: "check_select")
    var unCheckImage: UIImage? = CSPhotoDesignManager.instance.photoDetailUnCheckImage ?? UIImage(named: "check_default")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewController()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

//  IBAction
private extension CSPhotoGalleryDetailViewController {
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func checkBtnAction(_ sender: Any) {
        let identifier = PhotoManager.sharedInstance.getLocalIdentifier(at: currentIndexPath)
        PhotoManager.sharedInstance.setSelectedIndexPath(identifier: identifier)
        updateCheckBtnUI()
        updateCurrentSelectedCount()
        
        let vc = presentingViewController as? CSPhotoGalleryViewController
        vc?.updateCollectionViewCellUI(indexPath: currentIndexPath)
    }
    
    @IBAction func okBtnAction(_ sender: Any) {
        delegate?.getAssets(assets: PhotoManager.sharedInstance.assets)
        dismiss()
    }
}

//  MARK:- Init ViewController
fileprivate extension CSPhotoGalleryDetailViewController {
    fileprivate func setViewController() {
        setData()
        setView()
    }
    
    private func setData() {
        
    }
    
    private func setView() {
        scrollToCurrentIndexPath()
    }
    
    func updateCurrentSelectedCount() {
        DispatchQueue.main.async {
            self.checkCountLabel?.text = "\(PhotoManager.sharedInstance.assets.count)"
        }
    }
    
    func updateCurrentIndexLabel() {
        DispatchQueue.main.async {
            self.currentIndexLabel?.text = "\(self.currentIndexPath.item + 1)"
        }
    }
    
    func updateCurrentCollectionAssetCount() {
        DispatchQueue.main.async {
            self.currentCollectionCountLabel?.text = "\(PhotoManager.sharedInstance.assetsCount)"
        }
    }
    
    func updateCheckBtnUI() {
        DispatchQueue.main.async {
            let identifier = PhotoManager.sharedInstance.getLocalIdentifier(at: self.currentIndexPath)
            if PhotoManager.sharedInstance.isSelectedIndexPath(identifier: identifier) {
                self.checkBtn?.setImage(self.checkImage, for: .normal)
            } else {
                self.checkBtn?.setImage(self.unCheckImage, for: .normal)
            }
        }
    }
    
    func scrollToCurrentIndexPath() {
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: self.currentIndexPath, at: .left, animated: false)
        }
    }
}

//  MARK:- Extension
fileprivate extension CSPhotoGalleryDetailViewController {
    func dismiss() {
        let presentingVC = presentingViewController as! CSPhotoGalleryViewController
        presentingVC.scrollRectToVisible(indexPath: currentIndexPath)
        
        let asset = PhotoManager.sharedInstance.getCurrentCollectionAsset(at: currentIndexPath)
        let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        
        PhotoManager.sharedInstance.assetToImage(asset: asset, imageSize: size, isCliping: false) { image in
            self.currentImage = image
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//  MARK:- UICollectionView DataSource
extension CSPhotoGalleryDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoManager.sharedInstance.assetsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CSPhotoGalleryDetailCollectionViewCell
        let asset = PhotoManager.sharedInstance.getCurrentCollectionAsset(at: indexPath)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        
        let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        PhotoManager.sharedInstance.setThumbnailImage(at: indexPath, thumbnailSize: size, isCliping: false) { image in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        }
        
        return cell
    }
}

//  MARK:- UICollectionView Delegate
extension CSPhotoGalleryDetailViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            var visibleRect = CGRect()
            
            visibleRect.origin = collectionView.contentOffset
            visibleRect.size = collectionView.bounds.size
            
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint) {
                if currentIndexPath != visibleIndexPath {
                    prevIndexPath = currentIndexPath
                    currentIndexPath = visibleIndexPath
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

//  MARK:- UIScrollView Delegate
extension CSPhotoGalleryDetailViewController: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        let cell = collectionView.cellForItem(at: currentIndexPath) as? CSPhotoGalleryDetailCollectionViewCell
//        return cell?.imageView
//    }
}
