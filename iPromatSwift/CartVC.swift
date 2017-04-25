//
//  OrdersVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 21.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit
import CoreData


class CartVC: UITableViewController {

    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "OrderEntity", keyForSort: "itemId")
    
    var selectedIndex: IndexPath?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print (error)
        }
        
        self.tableView.allowsMultipleSelection = false
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections=fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cellName: String
        if selectedIndex == indexPath {
            cellName = "CartCell" //"OrderCellSelected"
        } else {
            cellName = "CartCell"
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CartCell

        let order = fetchedResultsController.object(at: indexPath) as! OrderEntity
        cell.order = order
        cell.vc = self

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let selectedIndex = selectedIndex {
            if selectedIndex == indexPath {
                return 110
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let order = fetchedResultsController.object(at: indexPath) as! OrderEntity
            CoreDataManager.instance.delete(object: order)
            
            do {
                try fetchedResultsController.performFetch()
            } catch {
                print (error)
            }

            tableView.reloadData();

        }
        
    }

}
