//
//  OrderCell.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 26.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
    var vc: CartVC?

    @IBOutlet weak var itemImage: UIImageView!
    
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
    
    
    @IBOutlet weak var itemQtyButton: UIButton!
    
    @IBAction func pressedQty(_ sender: AnyObject) {
        AppModule.sharedInstance.alertQty(view: vc!, handlerView: changeQty, qtyDefault: order!.qty)
    }
    
    func changeQty (sQty: String) {
        if let qty = Int64(sQty) {
            order!.qty = qty
            CoreDataManager.instance.commit()
            itemQtyButton.setTitle(String(qty), for: UIControlState.normal)
        } else {
            AppModule.sharedInstance.alertError("Неверное количество", view: vc!)
        }
    }
    
    @IBOutlet weak var btnDecrement: UIButton!
    
    
    @IBOutlet weak var btnIncrement: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let btnDecrement = btnDecrement {
            btnDecrement.layer.cornerRadius = 12
            btnIncrement.layer.cornerRadius = 12
        }
        itemQtyButton.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var order : OrderEntity? {
        didSet {
            itemName.text = order?.itemName
            itemQtyButton.setTitle(String(describing: order!.qty), for: UIControlState.normal)
            if let img = order?.itemImage {
                itemImage.imageFromUrl(img)
            }
        }
    }
    

}
