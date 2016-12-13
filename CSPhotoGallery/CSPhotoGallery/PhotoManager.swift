//
//  PhotoManager.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 8..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import Foundation
import Photos

enum Section: Int {
    case smartAlbums = 0
    case userCollections
    
    static let count = 2
}

enum CSPhotoImageType {
    case image
    case video
    
    var type: PHAssetMediaType {
        switch self {
        case .image:
            return .image
        case .video:
            return .video
        }
    }
}

class PhotoManager: NSObject {
    static var sharedInstance: PhotoManager = PhotoManager()
    
    fileprivate var smartAlbums: [PHAssetCollection] = []
    fileprivate var userCollections: [PHCollection] = []
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate let imageRequestOptions = PHImageRequestOptions()
    fileprivate var selectedIdentifiers: [String] = [] {
        didSet {
            selectedItemCount = selectedIdentifiers.count
        }
    }
    dynamic private(set) var selectedItemCount: Int = 0
    dynamic var currentCollection: PHAssetCollection! {
        didSet {
            selectedIdentifiers = []
            currentFetchResult = getAssetsInPHAssetCollection(collection: currentCollection)
        }
    }
    fileprivate var currentFetchResult: PHFetchResult<PHAsset>!

    public var mediaType: CSPhotoImageType = .image
    public var CHECK_MAX_COUNT = 20
    
    override private init() {
        super.init()
        
        initPhotoManager()
    }
}

//  MARK:- Init PhotoManager
extension PhotoManager {
    func initPhotoManager() {
        initPHAssetCollection()
        initImageRequestOptions()
    }
    
    //  MARK:- TODO
    private func initPHAssetCollection() {
        initSmartAlbumCollection()
        currentCollection = smartAlbums.first
        
        initUserCollection()
    }
    
    func initSmartAlbumCollection() {
        smartAlbums = []
        PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil).enumerateObjects({ collection, _, _ in
            if self.getPHAssetCollectionCount(collection: collection) > 0 {
                self.smartAlbums.append(collection)
            }
        })
        smartAlbums.sort {
            getPHAssetCollectionCount(collection: $0) > getPHAssetCollectionCount(collection: $1)
        }
    }
    
    func initUserCollection() {
        userCollections = []
        PHCollectionList.fetchTopLevelUserCollections(with: nil).enumerateObjects({ collection, _, _ in
            if self.getPHAssetCollectionCount(collection: collection as! PHAssetCollection) > 0 {
                self.userCollections.append(collection)
            }
        })
        userCollections.sort {
            getPHAssetCollectionCount(collection: $0 as! PHAssetCollection) > getPHAssetCollectionCount(collection: $1 as! PHAssetCollection)
        }
    }
    
    private func initImageRequestOptions() {
        imageRequestOptions.resizeMode = .exact
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.isSynchronous = false
    }
}

//  MARK:- PHAsset
extension PhotoManager {
    //  Get PHAsset at IndexPath
    private func getCurrentCollectionAsset(at indexPath: IndexPath) -> PHAsset {
        return currentFetchResult.object(at: indexPath.item)
    }
    
    //  Get PHAsset Count
    var assetsCount: Int {
        return currentFetchResult.count
    }
    
    var assets: [PHAsset] {
        var tempList: [PHAsset] = []
        selectedIdentifiers.forEach {
            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [$0], options: nil).firstObject ?? PHAsset()
            tempList.append(asset)
        }
        return tempList
    }
    
    //  Get localIdentifier
    func getLocalIdentifier(at indexPath: IndexPath) -> String {
        return getCurrentCollectionAsset(at: indexPath).localIdentifier
    }
    
    //  Set ThumbnailImage
    func setThumbnailImage(at indexPath: IndexPath, thumbnailSize: CGSize, completionHandler: ((UIImage)->())?) {
        let asset = getCurrentCollectionAsset(at: indexPath)
        assetToImage(asset: asset, imageSize: thumbnailSize, completionHandler: completionHandler)
    }
    
    func assetToImage(asset: PHAsset, imageSize: CGSize, completionHandler: ((UIImage)->())?) {
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: imageRequestOptions) { image, _ in
            if let thumbnameImage = image {
                let clopImage = PhotoUtil.cropImage(thumbnameImage)
                completionHandler?(clopImage)
            }
        }
    }
    
    //  Check selected IndexPath
    func isSelectedIndexPath(identifier: String) -> Bool {
        return selectedIdentifiers.index(of: identifier) != nil
    }
    
    //  Append selected IndexPath
    func setSelectedIndexPath(identifier: String) {
        if let index = selectedIdentifiers.index(of: identifier) {
            selectedIdentifiers.remove(at: index)
        } else {
            if selectedItemCount < CHECK_MAX_COUNT {
                selectedIdentifiers.append(identifier)
            }
        }
    }
    
    //  
    func performChanges(changeBlock: @escaping () -> (), completionHandler: ((Bool, Error?) -> ())?) {
        PHPhotoLibrary.shared().performChanges(changeBlock, completionHandler: completionHandler)
    }
}

//  MARK:- PHAssetCollection
extension PhotoManager {
    var smartAlbumsCount: Int {
        return smartAlbums.count
    }
    
    func getSmartAlbumsAssetCollection(index: Int) -> PHAssetCollection {
        return smartAlbums[index]
    }
    
    var userCollectionsCount: Int {
        return userCollections.count
    }
    
    func getUserCollection(index: Int) -> PHAssetCollection {
        return userCollections[index] as! PHAssetCollection
    }
    
    func getPHAssetCollectionCount(collection: PHAssetCollection) -> Int {
        return PHAsset.fetchAssets(in: collection, options: nil).countOfAssets(with: mediaType.type)
    }
    
    func getAssetsInPHAssetCollection(collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", CSPhotoImageType.image.type.rawValue)
        return PHAsset.fetchAssets(in: collection, options: fetchOptions)
    }
    
    func getCurrentAsset() -> PHFetchResult<PHAsset> {
        return currentFetchResult
    }
    
    func reloadCurrentAsset() {
        currentFetchResult = getAssetsInPHAssetCollection(collection: currentCollection)
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
