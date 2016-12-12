//
//  CSPhotoGalleryCollectionViewCell.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 7..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

protocol Reusable {}
extension Reusable {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}
extension UICollectionViewCell: Reusable {}

extension UICollectionView {
    func dequeueReusableCell<T: Reusable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

class CSPhotoGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var checkBtn: UIButton!
    
    @IBAction private func checkBtnAction(_ sender: Any) {
        if indexPath != nil {
            PhotoManager.sharedInstance.setSelectedIndexPath(indexPath: indexPath!)
            setButtonImage()
        }
    }
    
    var indexPath: IndexPath?
    
    var representedAssetIdentifier: String?
    
    func setButtonImage() {
        DispatchQueue.main.async {
            if PhotoManager.sharedInstance.isSelectedIndexPath(indexPath: self.indexPath!) {
                self.checkBtn.backgroundColor = UIColor.blue
            } else {
                self.checkBtn.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    func setPlaceHolderImage(image: UIImage?) {
        setImage(image: image)
    }
    
    func setImage(image: UIImage?) {
        self.imageView.image = image
    }
}
