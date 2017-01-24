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
    @IBAction func btnAction(_ sender: Any) {
        let designManager = CSPhotoDesignManager.instance
        
        //  Main
        designManager.photoGalleryOKButtonTitle = "OK"
        
        let vc = CSPhotoGalleryViewController.instance
        vc.delegate = self
        vc.CHECK_MAX_COUNT = 10
        vc.horizontalCount = 4
//        present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: CSPhotoGalleryDelegate {
    func getAssets(assets: [PHAsset]) {
        assets.forEach {
            let size = CGSize(width: $0.pixelWidth, height: $0.pixelHeight)
            PhotoManager.sharedInstance.assetToImage(asset: $0, imageSize: size, completionHandler: nil)
        }
    }
}
