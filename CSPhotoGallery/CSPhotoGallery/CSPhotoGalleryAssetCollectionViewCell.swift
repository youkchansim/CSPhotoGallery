//
//  CSPhotoGalleryAssetCollectionViewCell.swift
//  CSPhotoGallery
//
//  Created by Naver on 2016. 12. 13..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

class CSPhotoGalleryAssetCollectionViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumAssetCount: UILabel!
    
    func setAlbumImage(image: UIImage?) {
        albumImageView.image = image
    }
}
