//
//  PhotoDetailsViewController.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 3/30/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UIScrollViewDelegate {

    // image related
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // profile related
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userInfoLabel: UILabel!
    
    var unsplashPhoto: UnsplashPhoto?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userProfileImage.makeRounded()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.addSubview(photoImageView)
        
        guard
            let photo = self.unsplashPhoto,
            let photoUrl = photo.unsplashRegularImageURL()
        else {return}
        
        photoImageView.load(url: photoUrl)
        
        // TODO: replace image loading
        // init user info view
        if let linkStr = photo.user.profileImage?.small,
            let userImage = URL(string: linkStr) {
            userProfileImage.load(url: userImage)
        }

        // init label
        userInfoLabel?.text = "Instagram: \(photo.user.instagramUsername ?? "")"
    }
    
    func initWithPhoto(_ photo: UnsplashPhoto) {
        self.unsplashPhoto = photo
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let imageSaver = ImageSaver()

        guard
            let downloadUrlString = unsplashPhoto?.links.download,
            let downloadUrl = URL(string: downloadUrlString)
        else { return }
        
        imageSaver.downloadAndSaveImage(by: downloadUrl)
    }
    
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}


