//
//  NewOrderAdressProfile.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 23.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewOrderAdressCell: UITableViewCell {
    
    @IBOutlet weak var floorTxt: UILabel!
    @IBOutlet weak var addressTxt: UILabel!
    @IBOutlet weak var elevatorSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
