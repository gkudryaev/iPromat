//
//  Category.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 06.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class Category: UITableViewController {

    var searchItem: (lvl1: Catalog.Category, lvl2: Catalog.Category, lvl3: Catalog.Category, ind: Int, item: Catalog.Item)?
    
    var isSegueItem = false

    @IBAction func cancelSearch(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func searchItem(segue:UIStoryboardSegue) {
        catalog?.lvl1Selected = searchItem?.lvl1
        catalog?.lvl2Selected = searchItem?.lvl2
        catalog?.lvl3Selected = searchItem?.lvl3
        catalog?.itemSelected = searchItem?.item
        catalog?.itemIndex = searchItem?.ind
        isSegueItem = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isSegueItem {
            isSegueItem = false
            performSegue(withIdentifier: "Item", sender: nil)
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catalog = Catalog.sharedInstance
        if let catalog = catalog {
            catalog.delegate = self
        }
        
        categoryVC = self
        
        //tableView.layer.bor
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.black.cgColor
        
        let nb = self.navigationController?.navigationBar as! CatalogNB
        nb.navigationController = self.navigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let catalog = catalog {
            return catalog.categories.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category1", for: indexPath)

        if let catalog = catalog, let nameLabel = cell.viewWithTag(200) as? UILabel {
            let category = catalog.categories[(indexPath as NSIndexPath).row]
            nameLabel.text = category.name
            if let image = cell.viewWithTag(100) as? UIImageView? {
                image?.imageFromUrl(category.image)
            }
        }
        
        if let borderView = cell.viewWithTag(300) {
            borderView.layer.borderWidth = 1
            borderView.layer.cornerRadius = 10
            borderView.layer.borderColor = UIColor(white: 0.92, alpha: 1).cgColor
        }
        return cell
    }
    

    
    // MARK: - Navigation

    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "catalogSearch" {
            if segue.identifier == "Item" {
                if let vc = segue.destination as? Item {
                    vc.isSegueItem = true
                }
            } else {
                if let catalog = catalog {
                    let row = (self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row
                    catalog.lvl1Selected = catalog.categories[row!]
                }
            }
        }
    }
    
    
    
    

}

var categoryVC: UIViewController?


extension Category: CatalogDelegate {
    func loaded() {
        self.tableView.reloadData()
    }
}


