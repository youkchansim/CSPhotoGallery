//
//  PhotoManager.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 8..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import Foundation
import Photos

class PhotoManager {
    fileprivate var fetchResult: PHFetchResult<PHAsset>!
    fileprivate var assetCollection: PHAssetCollection?
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    static var sharedInstance: PhotoManager {
        return PhotoManager()
    }
    private init() {
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
    }
}

//  MARK:- PhotoManager Extension
extension PhotoManager {
    //  Get PHAsset Count
    func getAssetCount() -> Int {
        return fetchResult.count
    }
    
    //  Get PHAsset at IndexPath
    private func getAsset(at indexPath: IndexPath) -> PHAsset {
        return fetchResult.object(at: indexPath.item)
    }
    
    //  Get 
    func getLocalIdentifier(at indexPath: IndexPath) -> String {
        return getAsset(at: indexPath).localIdentifier
    }
    
    //  Set ThumbnailImage
    func setThumbnailImage(at indexPath: IndexPath, thumbnailSize: CGSize, completeionHandler: ((UIImage)->())?) {
        let asset = getAsset(at: indexPath)
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if let thumbnameImage = image {
                completeionHandler?(thumbnameImage)
            }
        })
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
