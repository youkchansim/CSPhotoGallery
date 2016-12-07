//
//  CSPhotoGalleryViewController.swift
//  CSPhotoGallery
//
//  Created by Youk Chansim on 2016. 12. 7..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

class CSPhotoGalleryViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var galleryTypeBtn: UIButton!
    @IBOutlet weak var galleryTypeArrow: UIImageView!
    
    @IBOutlet weak var checkCount: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    
    @IBAction func galleryTypeBtnAction(_ sender: Any) {
    }
    
    @IBAction func checkBtnAction(_ sender: Any) {
    }
    
    var CHECK_MAX_COUNT = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setViewController()
    }
}

extension CSPhotoGalleryViewController {
    fileprivate func setViewController() {
        setData()
        setView()
    }
    
    private func setData() {
        
    }
    
    private func setView() {
        
    }
}
