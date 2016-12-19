//
//  CSPhotoViewerTransition.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 15..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

class CSPhotoViewerTransition: NSObject, UIViewControllerTransitioningDelegate {
    var initialRect = CGRect.zero
    var originalImage = UIImage()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimation = CSPhotoViewerPresentAnimation(initialRect: initialRect, originalImage: originalImage)
        return presentAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimation = CSPhotoViewerDismissAnimation()
        return dismissAnimation
    }
}

class CSPhotoViewerPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let initialRect: CGRect
    var originalImage: UIImage
    
    init(initialRect: CGRect, originalImage: UIImage) {
        self.initialRect = initialRect
        self.originalImage = originalImage
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! CSPhotoGalleryDetailViewController
        let containerView = transitionContext.containerView
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        let imageView = UIImageView(image: originalImage)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = initialRect
        containerView.addSubview(imageView)
        
        toViewController.view.alpha = 0
        containerView.frame = toViewController.view.frame
        containerView.addSubview(toViewController.view)
        
        let frame = getImageScaleFactor(originImage: originalImage, standardFrame: toViewController.collectionView.frame)
        UIView.animate(withDuration: animationDuration) {
            imageView.frame = frame
        }
        
        UIView.animate(withDuration: animationDuration, delay: 0.2, options: [], animations: {
            toViewController.view.alpha = 1
        }) { complete in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class CSPhotoViewerDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animationDuration = self .transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! CSPhotoGalleryViewController
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! CSPhotoGalleryDetailViewController
        
        let originImage = fromViewController.currentImage ?? UIImage()
        let destinationFrame = toViewController.collectionViewCellFrame(at: fromViewController.currentIndexPath)
        
        let frame = getImageScaleFactor(originImage: originImage, standardFrame: fromViewController.collectionView.frame)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = originImage
        
        containerView.addSubview(imageView)
        UIView.animate(withDuration: animationDuration, animations: {
            fromViewController.view.alpha = 0
        })
        
        UIView.animate(withDuration: animationDuration, animations: {
            imageView.frame = destinationFrame
        }) { complete in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

fileprivate extension UIViewControllerAnimatedTransitioning {
    func getImageScaleFactor(originImage: UIImage, standardFrame: CGRect) -> CGRect {
        let imageWidth = CGFloat(originImage.cgImage!.width)
        let imageHeight = CGFloat(originImage.cgImage!.height)
        var scaleFactor: CGFloat = 1
        
        if imageWidth > imageHeight {
            scaleFactor = standardFrame.width / imageWidth
        } else {
            scaleFactor = standardFrame.height / imageHeight
        }
        
        let width = imageWidth * scaleFactor
        let height = imageHeight * scaleFactor
        let x = (standardFrame.width - width) / 2
        let y = (standardFrame.height - height) / 2 + standardFrame.origin.y
        
        return CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }
}
