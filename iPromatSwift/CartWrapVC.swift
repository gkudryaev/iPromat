//
//  OrdersWrapVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 08.02.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class CartWrapVC: UIViewController {

    @IBAction func requestPressed(_ sender: Any) {
        AppModule.sharedInstance.goStoreBoard(storeBoardName: "NewOrder")
    }
    
    @IBAction func pressBack(_ sender: Any) {
        let nc = navigationController as! CartNC
        let nb = nc.ncOrigin?.navigationBar as! CatalogNB
        nb.setQty()
        UIApplication.shared.keyWindow?.rootViewController = nc.ncOrigin
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
