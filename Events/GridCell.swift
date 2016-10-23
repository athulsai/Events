//
//  GridCell.swift
//  Events
//
//  Created by Athul Sai on 22/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    @IBOutlet var thumbnailImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
        titleLabel.text = ""
    }
}
