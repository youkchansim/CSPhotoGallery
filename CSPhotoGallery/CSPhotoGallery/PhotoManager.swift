//
//  PhotoManager.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 8..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import Foundation
import Photos

class PhotoManager: NSObject {
    static var sharedInstance: PhotoManager = PhotoManager()
    
    fileprivate var fetchResult: PHFetchResult<PHAsset>!
    fileprivate var assetCollection: PHAssetCollection?
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate let imageRequestOptions = PHImageRequestOptions()
    fileprivate var selectedIndexPaths: [IndexPath] = [] {
        didSet {
            selectedItemCount = selectedIndexPaths.count
        }
    }
    dynamic private(set) var selectedItemCount: Int = 0

    fileprivate let DEFAULT_CHECK_LIMIT_COUNT = 20
    public var CHECK_MAX_COUNT = 20
    
    override private init() {
        super.init()
        
        initPhotoManager()
        setImageRequestOptions()
    }
}

//  MARK:- Init PhotoManager
extension PhotoManager {
    func initPhotoManager() {
        initPHAssetCollection()
        initFetchAssets()
        initSelect()
    }
    
    //  MARK:- TODO
    private func initPHAssetCollection() {
        assetCollection = nil
    }
    
    private func initFetchAssets() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
    }
    
    private func initSelect() {
        selectedIndexPaths = []
    }
    
    fileprivate func setImageRequestOptions() {
        imageRequestOptions.resizeMode = .exact
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.isSynchronous = false
    }
}

//  MARK:- PhotoManager Extension
extension PhotoManager {
    //  Get PHAsset at IndexPath
    private func getAsset(at indexPath: IndexPath) -> PHAsset {
        return fetchResult.object(at: indexPath.item)
    }
    
    //  Get PHAsset Count
    var assetsCount: Int {
        return fetchResult.count
    }
    
    //  Get localIdentifier
    func getLocalIdentifier(at indexPath: IndexPath) -> String {
        return getAsset(at: indexPath).localIdentifier
    }
    
    //  Set ThumbnailImage
    func setThumbnailImage(at indexPath: IndexPath, thumbnailSize: CGSize, completeionHandler: ((UIImage)->())?) {
        let asset = getAsset(at: indexPath)
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: imageRequestOptions) { image, _ in
            if let thumbnameImage = image {
                let clopImage = PhotoUtil.cropImage(thumbnameImage)
                completeionHandler?(clopImage)
            }
        }
    }
    
    //  Check selected IndexPath
    func isSelectedIndexPath(indexPath: IndexPath) -> Bool {
        return selectedIndexPaths.index(of: indexPath) != nil
    }
    
    //  Append selected IndexPath
    func setSelectedIndexPath(indexPath: IndexPath) {
        if let index = selectedIndexPaths.index(of: indexPath) {
            selectedIndexPaths.remove(at: index)
        } else {
            if selectedItemCount < CHECK_MAX_COUNT {
                selectedIndexPaths.append(indexPath)
            }
        }
    }
    
    //  Get selected Indexpath
    func getSelectedIndexPath(indexPath: IndexPath) -> [IndexPath] {
        return selectedIndexPaths
    }
}

//  MARK:- Register object to receive change notification
extension PhotoManager {
    func register<T: PHPhotoLibraryChangeObserver>(object: T) {
        PHPhotoLibrary.shared().register(object)
    }
    
    func remover<T: PHPhotoLibraryChangeObserver>(object: T) {
        PHPhotoLibrary.shared().unregisterChangeObserver(object)
    }
}
