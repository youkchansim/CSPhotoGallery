//
//  CSPhotoGalleryCollectionViewCell.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 7..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

class CSPhotoGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var checkBtn: UIButton!
    @IBOutlet fileprivate weak var timeLabel: UILabel?
    
    var indexPath: IndexPath?
    var representedAssetIdentifier: String?
    
    override func prepareForReuse() {
        imageView.image = nil
        timeLabel?.text = nil
    }
}

//  MARK:- Extension
extension CSPhotoGalleryCollectionViewCell {
    func setButtonImage() {
        DispatchQueue.main.async {
            if PhotoManager.sharedInstance.isSelectedIndexPath(identifier: self.representedAssetIdentifier!) {
                self.checkBtn.setImage(UIImage(named: "check_select"), for: .normal)
            } else {
                self.checkBtn.setImage(UIImage(named: "check_default"), for: .normal)
            }
        }
    }
    
    func setPlaceHolderImage(image: UIImage?) {
        setImage(image: image)
    }
    
    func setImage(image: UIImage?) {
        imageView.image = image
    }
    
    func setTime(time: String) {
        timeLabel?.text = time
    }
}

//  MARK:- IBAction
extension CSPhotoGalleryCollectionViewCell {
    @IBAction private func checkBtnAction(_ sender: Any) {
        if indexPath != nil {
            PhotoManager.sharedInstance.setSelectedIndexPath(identifier: representedAssetIdentifier!)
            setButtonImage()
        }
    }
}
