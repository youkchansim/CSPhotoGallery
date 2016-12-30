//
//  ViewController.swift
//  CSPhotoGallery
//
//  Created by chansim.youk on 12/30/2016.
//  Copyright (c) 2016 chansim.youk. All rights reserved.
//

import UIKit
import CSPhotoGallery
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let designManager = CSPhotoDesignManager.instance
        
        //  Main
        designManager.photoGalleryOKButtonTitle = "OK"
        
        //  Detail
        designManager.photoDetailOKButtonTitle = "OK"
        
        let vc = CSPhotoGalleryViewController.instance
        vc.delegate = self
        vc.CHECK_MAX_COUNT = 10
        vc.horizontalCount = 4
        present(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: CSPhotoGalleryDelegate {
    func getAssets(assets: [PHAsset]) {
        print(assets.count)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
