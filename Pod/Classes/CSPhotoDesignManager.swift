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
    
    //  Photo collection view
    public var photoGalleryBackButtonImage: UIImage?
    
    public var photoGalleryOKButtonTitle: String?
    
    public var photoGalleryCheckImage: UIImage?
    
    public var photoGalleryUnCheckImage: UIImage?
    
    //  Photo detail view
    public var photoDetailBackButtonImage: UIImage?
    
    public var photoDetailOKButtonTitle: String?
    
    public var photoDetailCheckImage: UIImage?
    
    public var photoDetailUnCheckImage: UIImage?
}
