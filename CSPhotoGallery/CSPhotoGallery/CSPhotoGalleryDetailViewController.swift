//
//  CSPhotoGalleryDetailViewController.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 7..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

class CSPhotoGalleryDetailViewController: UIViewController {
    static var sharedInstance: CSPhotoGalleryDetailViewController {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! CSPhotoGalleryDetailViewController
    }

    @IBOutlet weak var currentIndexLabel: UILabel!
    @IBOutlet weak var currentCollectionCountLabel: UILabel! {
        didSet {
            currentCollectionCountLabel.text = "\(PhotoManager.sharedInstance.assetsCount)"
        }
    }
    
    @IBOutlet weak var checkCountLabel: UILabel! {
        didSet {
            checkCountLabel.text = "\(PhotoManager.sharedInstance.assets.count)"
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var checkBtn: UIButton!
    
    var delegate: CSPhotoGalleryDelegate?
    var currentIndexPath: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            if PhotoManager.sharedInstance.assetsCount > 0 {
                setCurrentIndexLabel()
                updateCheckBtnUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewController()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

private extension CSPhotoGalleryDetailViewController {
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func checkBtnAction(_ sender: Any) {
        let identifier = PhotoManager.sharedInstance.getLocalIdentifier(at: currentIndexPath)
        PhotoManager.sharedInstance.setSelectedIndexPath(identifier: identifier)
        updateCheckBtnUI()
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
        setCurrentIndexLabel()
        scrollToCurrentIndexPath()
    }
    
    func scrollToCurrentIndexPath() {
        collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: false)
    }
    
    func setCurrentIndexLabel() {
        DispatchQueue.main.async {
            self.currentIndexLabel.text = "\(self.currentIndexPath.item + 1)"
        }
    }
}

//  MARK:- Extension
fileprivate extension CSPhotoGalleryDetailViewController {
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateCheckBtnUI() {
        DispatchQueue.main.async {
            let identifier = PhotoManager.sharedInstance.getLocalIdentifier(at: self.currentIndexPath)
            if PhotoManager.sharedInstance.isSelectedIndexPath(identifier: identifier) {
                self.checkBtn.setImage(UIImage(named: "check_select"), for: .normal)
            } else {
                self.checkBtn.setImage(UIImage(named: "check_default"), for: .normal)
            }
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
        let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        currentIndexPath = visibleIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
