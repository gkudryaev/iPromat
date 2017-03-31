//
//  ItemCell.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 19.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var customImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var viewButtons: UIView!
    

    var item: Catalog.Item! {
        didSet {
            nameLabel.text = item.name
            descLabel.text = item.name
            if let img = item.image {
                customImage.imageFromUrl(img)
            }
            addButton.isHidden = true
            detailButton.isHidden = true
            viewButtons.isHidden = true
        }        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    


}
