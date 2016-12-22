//
//  DesignManager.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 22..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//
//  This class manage design of CSPhotoGallery

import UIKit

public class DesignManager {
    public static var instance: DesignManager = DesignManager()
    
    public var photoGalleryBackgroundColor: UIColor? {
        didSet {
            
        }
    }
    
    public var navigationBackgroundColor: UIColor? {
        didSet {
            
        }
    }
    
    public var navigationBackButtonImage: UIImage? {
        didSet {
            
        }
    }
    
    public var navigationCheckButtonTitle: String? {
        didSet {
            
        }
    }
}
