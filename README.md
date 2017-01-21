# CSPhotoGallery

[![Version](https://img.shields.io/cocoapods/v/CSPhotoGallery.svg?style=flat)](http://cocoapods.org/pods/CSPhotoGallery)
[![License](https://img.shields.io/cocoapods/l/CSPhotoGallery.svg?style=flat)](http://cocoapods.org/pods/CSPhotoGallery)
[![Platform](https://img.shields.io/cocoapods/p/CSPhotoGallery.svg?style=flat)](http://cocoapods.org/pods/CSPhotoGallery)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![Swift 3.0+](https://img.shields.io/badge/Swift-3.0%2B-orange.svg)

- This is very simple and light photo browser written swift. and also you can show images or videos.

![Sample Project](Example/csphotogallery.gif)
![Sample Project](Example/csphotogallery2.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CSPhotoGallery is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CSPhotoGallery"
```

## Usage

First Step  - `@import CSPhotoGallery` to your project 

Second Step - Add a delegate `CGPhotoGalleryDelegate` to your class & add two delegate methods 
```Swift
func getAssets(assets: [PHAsset]) {
  // if you implement this delegate function, you will receive assets
}

func dismiss() {
  //  Photo browser dismiss
  // ex)
  //  dismiss(animated: true) {
  //   do something
  //  }
}
```
Third Step - Present a CSPhotoGalleryViewController

```Swift
let vc = CSPhotoGalleryViewController.instance
vc.delegate = self
vc.CHECK_MAX_COUNT = 20
vc.horizontalCount = 3
vc.mediaType = .image //  or .video
present(vc, animated: true)
```
And you can customize ui design
```Swift
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
```

## Author

chansim.youk, dbrckstla@naver.com

## License

CSPhotoGallery is available under the MIT license. See the LICENSE file for more info.
