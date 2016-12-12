//
//  CSPhotoGalleryDelegate.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 12..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import Photos

protocol CSPhotoGalleryDelegate {
    func getAssets(assets: [PHAsset])
}
