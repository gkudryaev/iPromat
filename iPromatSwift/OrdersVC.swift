//
//  OrderListVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 29.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class OrdersVC: UITableViewController {
    
    var statuses: [Order.Status] = []
    var statusOrders: [[Order]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        requestOrderList()
    }
    
    func requestOrderList () {
        JsonHelper.request(.orderList,
                           ["id":userData.id],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseOrderList(json: json, error: error)
        })
    }
    func responseOrderList (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            refresh (json: json)
        }
    }
    
    func refresh (json: [String: Any]?) {
        if let ordersJson = json? ["orders"] as? [Any] {
            (statuses, statusOrders) = Order.orders(json: ordersJson)
        }
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return statuses.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusOrders[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath)

        let order = statusOrders[indexPath.section] [indexPath.row]
        cell.textLabel?.text = order.lines.first?.item.name
        if order.lines.count > 1 {
            cell.textLabel?.text  = cell.textLabel!.text!  + " (и еще \(order.lines.count-1))"
        }
        cell.detailTextLabel?.text = "" //String(order.id)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let orderId = statusOrders[indexPath.section][indexPath.row].id
            requestOrderCancel(orderId)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return statuses[section].name
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func requestOrderCancel (_ orderId: Int64) {
        JsonHelper.request(.orderCancel,
                           ["id":userData.id,
                            "order_id": orderId],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseOrderList(json: json, error: error)
        })
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? OrderVC {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.order = statusOrders[indexPath.section][indexPath.row]
            }
        }
    }
}

