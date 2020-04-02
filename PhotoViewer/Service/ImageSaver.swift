//
//  ImageSaver.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 4/2/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    
    func downloadAndSaveImage (by url:URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self?.writeToPhotoAlbum(image: image)
                }
            }
        }
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
