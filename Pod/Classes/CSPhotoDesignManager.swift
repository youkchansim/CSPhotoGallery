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
    
    //  Photo detail view
    public var photoDetailBackButtonImage: UIImage?
    
    //  OK Button Title
    public var photoGalleryOKButtonTitle: String?
    
    //  Check Image
    public var photoGalleryCheckImage: UIImage?
    
    //  UnCheck Image
    public var photoGalleryUnCheckImage: UIImage?
    
    //  When OK Button is hidden, CheckCountLabel and CheckBtn is hidden  
    public var isOKButtonHidden = false
}
