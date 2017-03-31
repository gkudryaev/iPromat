//
//  NewOrderConfirmVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 27.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewOrderConfirmVC: UITableViewController {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var pc: NewOrderPC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let pc = pc {
            for vc in pc.vcs {
                switch vc {
                case let vc as NewOrderAddressVC:
                    addressLabel.text = vc.address!
                case let vc as NewOrderDateVC:
                    dateLabel.text =
                        vc.dateRange [vc.datePickerView.selectedRow(inComponent: 0)] + " " +
                        vc.timeRange [vc.timePickerView.selectedRow(inComponent: 0)]
                case let vc as NewOrderCommentVC:
                    commentLabel.text = vc.commentLabel.text
                default: break
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func requestOrder () {
        var params = orderHeader()
        params["lines"] = orderLines()
        JsonHelper.request(.order,
                           params,
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseOrder(json: json, error: error)
        })
    }
    
    func responseOrder (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            if let json = json {
                AppModule.sharedInstance.alertMessage("Заявка создана", view: self)
                
                clearBasket()

                AppModule.sharedInstance.goStoreBoard (storeBoardName: "Catalog")
            }
        }
    }
    
    func clearBasket () {
        let fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "OrderEntity", keyForSort: "itemId")
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print (error)
        }
        
        
        for order in fetchedResultsController.fetchedObjects! {
            Storage.shared.context.delete(order)
        }
        CoreDataManager.instance.commit ()

    }
    
    func orderHeader () -> [String: Any] {
        
        var header: [String:Any] = ["id": userData.id]
        
        if let pc = pc {
            for vc in pc.vcs {
                switch vc {
                case let vc as NewOrderAddressVC:
                    header ["address"] = vc.address
                    header ["floor"] = vc.floor
                    
                    if let cell = vc.tableView.cellForRow(at: IndexPath(row:1, section:0)) as? NewOrderAdressCell
                    {
                        header ["is_elevator"] = cell.elevatorSwitch.isOn ? "1" : "0"
                        
                    }
                    
                case let vc as NewOrderDateVC:
                    header ["dat"] = vc.dateRange [vc.datePickerView.selectedRow(inComponent: 0)]
                    header ["period"] = vc.timeRange [vc.timePickerView.selectedRow(inComponent: 0)]
                case let vc as NewOrderCommentVC:
                    header ["comment"] = vc.commentLabel.text
                    header ["is_splitting"] = vc.splitSwitch.isOn ? "1" : "0"
                default: break
                }
            }
        }
        return header
    }
    
    func orderLines () -> [[String: Any]] {
        
        var lines: [[String: Any]] = []

        let fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "OrderEntity", keyForSort: "itemId")

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print (error)
        }
        
        for order in fetchedResultsController.fetchedObjects! {
            if let order = order as? OrderEntity {
                lines.append([
                    "item": order.itemName!,
                    "qty": order.qty
                    ])
                print ("item: \(order.itemName), qty: \(order.qty)")
            }
        }
        
        return lines
    }
    

}
