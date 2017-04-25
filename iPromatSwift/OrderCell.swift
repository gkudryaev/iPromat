//
//  OrderListLinesCell.swift
//  iPromatSwift
//
//  Created by Grisha on 4/20/17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var quantity: UILabel!

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var customImage: UIImageView!

    @IBOutlet weak var orderCost: UILabel!
    @IBOutlet weak var orderDelivery: UILabel!

    @IBAction func confirmOrder(_ sender: Any) {
        requestOrderStatus()
    }
    
    var vc: OrderVC?

    func requestOrderStatus () {
        JsonHelper.request(.orderStatus,
                           ["id":userData.id,
                            "order_id": vc?.order.id,
                            "status": Order.Status.EXECUTING.rawValue
                            ],
                           vc,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseOrderList(json: json, error: error)
        })
    }

    func responseOrderList (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: vc!)
        } else {
            vc?.navigationController?.popViewController(animated: true)
            if let vc = vc?.navigationController?.visibleViewController as? OrdersVC {
                vc.refresh(json: json)
            }
 
        }
    }

}
