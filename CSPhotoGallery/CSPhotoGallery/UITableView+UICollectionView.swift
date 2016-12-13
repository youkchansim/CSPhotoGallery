//
//  UITableView+UICollectionView.swift
//  CSPhotoGallery
//
//  Created by Naver on 2016. 12. 13..
//  Copyright © 2016년 Youk Chansim. All rights reserved.
//

import UIKit

protocol Reusable {}
extension Reusable {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}
extension UICollectionViewCell: Reusable {}
extension UICollectionView {
    func dequeueReusableCell<T: Reusable>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UITableViewCell: Reusable {}
extension UITableView {
    func dequeueReusableCell<T: Reusable>() -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    }
}
