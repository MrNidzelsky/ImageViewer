//
//  ImageExtension.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 4/5/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    // load image with returning image
    func load(url: URL, completion: @escaping (UIImage?) -> Void ) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion(image)
                    }
                }
            }
        }
    }

    // just load image
    func load(url: URL) {
        load(url: url) { (image) in }
    }
    
    // make imageview rounded shape
    func makeRounded() {
        self.layer.borderWidth = 8
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
