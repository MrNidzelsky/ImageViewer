//
//  PhotoListCell.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 3/30/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import UIKit

class PhotoListCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoDescriptionLabel: UILabel!
    
    override func prepareForReuse() {
        imageView.image = nil
        photoDescriptionLabel.text = nil
    }
}

