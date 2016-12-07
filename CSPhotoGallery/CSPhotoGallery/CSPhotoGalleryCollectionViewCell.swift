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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBAction func checkBtnAction(_ sender: Any) {
        
    }
}
