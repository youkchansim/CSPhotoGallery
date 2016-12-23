//
//  CSPhotoGalleryDetailCollectionViewCell.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 14..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

class CSPhotoGalleryDetailCollectionViewCell: UICollectionViewCell {
    
    var representedAssetIdentifier: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
            doubleTapGesture.numberOfTapsRequired = 2
            doubleTapGesture.delaysTouchesBegan = true
            scrollView.addGestureRecognizer(doubleTapGesture)
        }
    }
    
    override func prepareForReuse() {
        representedAssetIdentifier = nil
        imageView.image = nil
        scrollView.setZoomScale(1.0, animated: true)
    }
}

//  MARK:- Extension
extension CSPhotoGalleryDetailCollectionViewCell {
    func doubleTap(gesture: UIGestureRecognizer) {
        if scrollView.zoomScale > 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let scale: CGFloat = 5.0
            let point = gesture.location(in: imageView)
            
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
        }
    }
}
