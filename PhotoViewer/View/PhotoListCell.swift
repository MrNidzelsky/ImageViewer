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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 10) / 2
        
        if let descriptionLabel = self.photoDescriptionLabel {
            photoDescriptionLabel.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute:.width, relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: cellWidth))
        }
    }
}

