//
//  CatalogSearchNB.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 21.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class CatalogSearchNB: UINavigationBar {
    
    var search: UISearchBar = UISearchBar()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addSubview(search)
        
    }
}
