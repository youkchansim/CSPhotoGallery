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
    case allPhotos = 0
    case smartAlbums
    case userCollections
    
    static let count = 3
}

enum SegueIdentifier: String {
    case showAllPhotos
    case showCollection
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
    
    fileprivate var allPhotos: PHFetchResult<PHAsset>!
    fileprivate var smartAlbums: [PHAssetCollection] = []
    fileprivate var userCollections: [PHCollection] = []
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate let imageRequestOptions = PHImageRequestOptions()
    fileprivate var selectedIndexPaths: [IndexPath] = [] {
        didSet {
            selectedItemCount = selectedIndexPaths.count
        }
    }
    dynamic private(set) var selectedItemCount: Int = 0

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
        initFetchAssets()
        initSelect()
        
        setImageRequestOptions()
    }
    
    //  MARK:- TODO
    private func initPHAssetCollection() {
        smartAlbums = []
        PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil).enumerateObjects({ collection, _, _ in
            if self.getPHAssetCollectionCount(collection: collection) > 0 {
                self.smartAlbums.append(collection)
            }
        })
        
        userCollections = []
        PHCollectionList.fetchTopLevelUserCollections(with: nil).enumerateObjects({ collection, _, _ in
            if self.getPHAssetCollectionCount(collection: collection as! PHAssetCollection) > 0 {
                self.userCollections.append(collection)
            }
        })
    }
    
    private func initFetchAssets() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        allPhotos = PHAsset.fetchAssets(with: mediaType.type, options: allPhotosOptions)
    }
    
    private func initSelect() {
        selectedIndexPaths = []
    }
    
    private func setImageRequestOptions() {
        imageRequestOptions.resizeMode = .exact
        imageRequestOptions.deliveryMode = .highQualityFormat
        imageRequestOptions.isSynchronous = false
    }
}

//  MARK:- PHAsset
extension PhotoManager {
    //  Get PHAsset at IndexPath
    private func getAllPhotosAsset(at indexPath: IndexPath) -> PHAsset {
        return allPhotos.object(at: indexPath.item)
    }
    
    //  Get PHAsset Count
    var assetsCount: Int {
        return allPhotos.count
    }
    
    var assets: [PHAsset] {
        var tempList: [PHAsset] = []
        selectedIndexPaths.forEach {
            let asset = allPhotos.object(at: $0.item)
            tempList.append(asset)
        }
        return tempList
    }
    
    //  Get localIdentifier
    func getLocalIdentifier(at indexPath: IndexPath) -> String {
        return getAllPhotosAsset(at: indexPath).localIdentifier
    }
    
    //  Set ThumbnailImage
    func setThumbnailImage(at indexPath: IndexPath, thumbnailSize: CGSize, completeionHandler: ((UIImage)->())?) {
        let asset = getAllPhotosAsset(at: indexPath)
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

//  MARK:- PHAssetCollection
extension PhotoManager {
    var smartAlbumsCount: Int {
        return smartAlbums.count
    }
    
    func getSmartAlbumsAssetCollection(indexPath: IndexPath) -> PHAssetCollection {
        return smartAlbums[indexPath.item]
    }
    
    var userCollectionsCount: Int {
        return userCollections.count
    }
    
    func getUserCollection(indexPath: IndexPath) -> PHAssetCollection {
        return userCollections[indexPath.item] as! PHAssetCollection
    }
    
    func getPHAssetCollectionCount(collection: PHAssetCollection) -> Int {
        return PHAsset.fetchAssets(in: collection, options: nil).countOfAssets(with: mediaType.type)
    }
    
    func setFetchResult(collection: PHAssetCollection, indexPath: IndexPath)-> PHAsset {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        return PHAsset.fetchAssets(in: collection, options: fetchOptions).object(at: indexPath.item)
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
