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
    @IBOutlet weak var photoDescriptionLabel: UILabel!
    
    var unsplashPhoto: UnsplashPhoto?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userProfileImage?.makeRounded()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        guard
            let photo = self.unsplashPhoto,
            let photoUrl = photo.unsplashRegularImageURL()
        else { return }
        
        photoImageView.load(url: photoUrl)
        
        // TODO: replace image loading
        // init user info view
        if let linkStr = photo.user.profileImage?.medium,
            let userImage = URL(string: linkStr) {
            userProfileImage?.load(url: userImage)
        }

        var userInfoString = String()
        
        // add user name
        if let username = photo.user.name {
            userInfoString += username
        }
        
        // add instagram username
        if let instagramUsername = photo.user.instagramUsername {
            userInfoString += "\nInstagram account: \(instagramUsername)"
        }
        
        // init userinfo label
        userInfoLabel?.text = userInfoString
        
        // init photo description label
        var photoDescriptionString = String()
        if let photoDescription = photo.description {
            photoDescriptionString += photoDescription
        }
        
        if let locatonInfo = photo.location {
            photoDescriptionString += "\nLocation: \(locatonInfo)"
        }
        
        photoDescriptionLabel?.text = photoDescriptionString
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


