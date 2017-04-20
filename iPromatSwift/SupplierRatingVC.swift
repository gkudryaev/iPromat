//
//  SupplierRatingVC.swift
//  iPromatSwift
//
//  Created by Grisha on 4/13/17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class SupplierRatingVC: UITableViewController {
    
    var rating: Int64?
    var supplier: String?
    
    @IBOutlet weak var ratingCosmos: CosmosView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ratingCosmos.rating = Double (rating ?? 5)
    }


    // MARK: - Table view data source

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        rating = Int64 (ratingCosmos.rating)
    }
    
}
