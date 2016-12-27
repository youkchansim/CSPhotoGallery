//
//  DesignManager.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 22..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//
//  This class manage design of CSPhotoGallery

import UIKit

public class CSPhotoDesignManager {
    public static var instance: CSPhotoDesignManager = CSPhotoDesignManager()
    
    private let photoGalleryViewController = CSPhotoGalleryViewController.instance
    private let photoDetailViewController = CSPhotoGalleryDetailViewController.instance
    
    //  Photo collection view
    public var photoGalleryBackButtonImage: UIImage? {
        didSet {
            photoGalleryViewController.backButtonImage = photoGalleryBackButtonImage
        }
    }
    
    public var photoGalleryOKButtonTitle: String? {
        didSet {
            photoGalleryViewController.okButtonTitle = photoGalleryOKButtonTitle
        }
    }
    
    public var photoGalleryCheckImage: UIImage? {
        didSet {
            photoGalleryViewController.checkImage = photoGalleryCheckImage
        }
    }
    
    public var photoGalleryUnCheckImage: UIImage? {
        didSet {
            photoGalleryViewController.unCheckImage = photoGalleryUnCheckImage
        }
    }
    
    //  Photo detail view
    public var photoDetailnBackButtonImage: UIImage? {
        didSet {
            photoDetailViewController.backButtonImage = photoDetailnBackButtonImage
        }
    }
    
    public var photoDetailOKButtonTitle: String? {
        didSet {
            photoDetailViewController.okButtonTitle = photoDetailOKButtonTitle
        }
    }
    
    public var photoDetailCheckImage: UIImage? {
        didSet {
            photoDetailViewController.checkImage = photoDetailCheckImage
        }
    }
    
    public var photoDetailUnCheckImage: UIImage? {
        didSet {
            photoDetailViewController.unCheckImage = photoDetailUnCheckImage
        }
    }
}
