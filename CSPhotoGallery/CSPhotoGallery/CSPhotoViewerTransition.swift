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
        let dismissAnimation = CSPhotoViewerDismissAnimation(initialRect: initialRect, originalImage: originalImage)
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
        imageView.frame = initialRect
        
        let imageWidth = CGFloat(originalImage.cgImage!.width)
        let imageHeight = CGFloat(originalImage.cgImage!.height)
        var scaleFactor: CGFloat = 1
        
        if imageWidth > imageHeight {
            scaleFactor = toViewController.collectionView.frame.width / imageWidth
        } else {
            scaleFactor = toViewController.collectionView.frame.height / imageHeight
        }
        
        let width = imageWidth * scaleFactor
        let height = imageHeight * scaleFactor
        let x = (toViewController.collectionView.frame.width - width) / 2
        let y = (toViewController.collectionView.frame.height - height) / 2 + toViewController.collectionView.frame.origin.y
        let frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
        
        containerView.addSubview(imageView)
        toViewController.view.alpha = 0
        containerView.frame = toViewController.view.frame
        containerView.addSubview(toViewController.view)
        
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
    let initialRect: CGRect
    let originalImage: UIImage
    
    init(initialRect: CGRect, originalImage: UIImage) {
        self.initialRect = initialRect
        self.originalImage = originalImage
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! CSPhotoGalleryDetailViewController
        let animationDuration = self .transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        
        let imageView = UIImageView(frame: fromViewController.currentImageView!.frame)
        imageView.image = originalImage.clipRect
        
        containerView.addSubview(imageView)
        fromViewController.view.alpha = 0
        
        UIView.animate(withDuration: animationDuration, animations: {
            imageView.frame = self.initialRect
        }) { complete in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
