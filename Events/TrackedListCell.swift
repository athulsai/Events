//
//  TrackedListCell.swift
//  Events
//
//  Created by Athul Sai on 23/10/16.
//  Copyright © 2016 Athul Sai. All rights reserved.
//

import UIKit

class TrackedListCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eventImageView.image = nil
        titleLabel.text = ""
        placeLabel.text = ""
        entryLabel.text = ""
    }

}
