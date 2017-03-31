//
//  Item.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 19.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class Item: UITableViewController {
    
    var selectedIndex: IndexPath?
    var isSegueItem = false

    @IBAction func fromSearch (segue:UIStoryboardSegue) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isSegueItem {
            isSegueItem = false
            let row = IndexPath(row: (catalog?.itemIndex)!, section: 0)
            selectedIndex = row
            //сначала изменяем размер
            //tableView.reloadRows(at: [row], with: .fade)
            tableView.selectRow(at: row as IndexPath, animated: true, scrollPosition: .middle)
            //теперь убираем выделение
            tableView.reloadRows(at: [row], with: .fade)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func addDidPressed(_ sender: AnyObject) {

        AppModule.sharedInstance.alertQty(view: self, handlerView: setQty, qtyDefault: nil )
        
    }
    
    func setQty (sQty: String) -> Void{
        
        if let qty = Int64 (sQty), qty>0 {
            let item = catalog?.lvl3Selected?.items[(selectedIndex?.row)!]
            CoreDataManager.instance.addOrder(itemId:0, itemName: item?.name, itemImage:item?.image, qty: qty)
            
            let nb = self.navigationController?.navigationBar as! CatalogNB
            
            nb.setQty()

        } else {
            AppModule.sharedInstance.alertError("Неверное количество", view: self)
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (catalog?.lvl3Selected?.items.count)!
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell

        let item = catalog?.lvl3Selected?.items[(indexPath as NSIndexPath).row]
        
        cell.item = item
        
        if let selectedIndex = selectedIndex {
            if selectedIndex == indexPath {
                cell.viewButtons.isHidden = false
                cell.addButton.isHidden = false
                cell.detailButton.isHidden = false
                return cell
            }
        }
        cell.viewButtons.isHidden = true
        cell.addButton.isHidden = true
        cell.detailButton.isHidden = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let selectedIndex = selectedIndex {
            if selectedIndex == indexPath {
                return 148
            }
        }
        return 84
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let oldIndex = selectedIndex
        selectedIndex = indexPath
        
        if let oldIndex = oldIndex {
            tableView.reloadRows(at: [oldIndex, indexPath], with: .fade)
        } else {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "itemDetail") {
            if let itemDetail = segue.destination as? ItemDetail {
                let item = catalog?.lvl3Selected?.items[(selectedIndex?.row)!]
                itemDetail.item = item
            }
        }
    
        
    }
    

}
