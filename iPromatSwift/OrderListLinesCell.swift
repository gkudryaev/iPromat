//
//  OrderListLinesCell.swift
//  iPromatSwift
//
//  Created by Grisha on 4/20/17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class OrderListLinesCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var quantity: UILabel!

    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var orderCost: UILabel!
    @IBAction func confirmOrder(_ sender: Any) {
    }
    @IBOutlet weak var orderDelivery: UILabel!

}
