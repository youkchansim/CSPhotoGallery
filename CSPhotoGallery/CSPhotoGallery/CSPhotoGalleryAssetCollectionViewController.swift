//
//  CSPhotoGalleryAssetCollectionViewController.swift
//  CSPhotoGallery
//
//  Created by Naver on 2016. 12. 13..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

class CSPhotoGalleryAssetCollectionViewController: UIViewController {
    static var sharedInstance: CSPhotoGalleryAssetCollectionViewController {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! CSPhotoGalleryAssetCollectionViewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var isHidden: Bool = true {
        didSet {
            isHidden ? disappear() : appear()
        }
    }
    
    var viewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

//  MARK:- ViewController Extension
extension CSPhotoGalleryAssetCollectionViewController {
    fileprivate func appear() {
        showView(height: viewHeight)
    }
    
    fileprivate func disappear() {
        showView(height: 0)
    }
    
    private func showView(height: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.view.frame.size.height = height
            self.view.layoutIfNeeded()
        }
    }
}

//  MARK:- TableView DataSource
extension CSPhotoGalleryAssetCollectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return PhotoManager.sharedInstance.smartAlbumsCount
        case .userCollections: return PhotoManager.sharedInstance.userCollectionsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as CSPhotoGalleryAssetCollectionViewCell
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            cell.albumName.text = "모든 사진"
            cell.albumAssetCount.text = "\(PhotoManager.sharedInstance.assetsCount)"
            return cell
            
        case .smartAlbums:
            let collection = PhotoManager.sharedInstance.getSmartAlbumsAssetCollection(indexPath: indexPath)
            cell.albumName.text = collection.localizedTitle
            cell.albumAssetCount.text = "\(PhotoManager.sharedInstance.getPHAssetCollectionCount(collection: collection))"
            return cell
            
        case .userCollections:
            let collection = PhotoManager.sharedInstance.getUserCollection(indexPath: indexPath)
            cell.albumName.text = collection.localizedTitle
            cell.albumAssetCount.text = "\(PhotoManager.sharedInstance.getPHAssetCollectionCount(collection: collection))"
            return cell
        }
    }
}

//  MARK:- TableView Delegate
extension CSPhotoGalleryAssetCollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
}
