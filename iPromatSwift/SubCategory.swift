//
//  SubCategory.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 13.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit



class SubCategory: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     }
    
   
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let catalog = catalog {
            return (catalog.lvl1Selected?.subCategory.count)!
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category2", for: indexPath)
        
        if let catalog = catalog, let nameLabel = cell.viewWithTag(200) as? UILabel {
            let category = catalog.lvl1Selected?.subCategory[(indexPath as NSIndexPath).row]
            nameLabel.text = category!.name
            //let i = cell.viewWithTag(100)
            //print ("\(i)")
            if let image = cell.viewWithTag(100) as? UIImageView? {
                
                //image?.imageFromUrl("http://ipromat.ru/PriceImsges/СН003893.jpg")
                image?.imageFromUrl(category?.image)

            }
        }
        
        if let borderView = cell.viewWithTag(300) {
            borderView.layer.borderWidth = 1
            borderView.layer.cornerRadius = 10
            borderView.layer.borderColor = UIColor(white: 0.92, alpha: 1).cgColor
        }

        
        return cell
    }
    
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let catalog = catalog {
            let row = (self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row
            catalog.lvl2Selected = catalog.lvl1Selected?.subCategory[row!]
        }
        
        
        //        self.detailfo
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
