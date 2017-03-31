//
//  OrderListVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 29.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class OrderListVC: UITableViewController {

    var orders: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        requestOrderList()
        /*
        orders.append(
            Order(id: 1, address: "address", status: "NEW", lines: [Order.Line(item: "product", qty: 100)])
        )
 */
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
            orders.removeAll()
            if let ordersJson = json? ["orders"] as? [Any] {
                for orderJson in ordersJson {
                    if let orderJson = orderJson as? [String: Any] {
                        var lines: [Order.Line] = []
                        if let linesJson = orderJson["lines"] as? [Any] {
                            for lineJson in linesJson {
                                if let lineJson = lineJson as? [String: Any] {
                                    lines.append(Order.Line(
                                        item: lineJson["item"] as! String,
                                        qty: lineJson["qty"] as! Int64
                                    ))
                                }
                            }
                        }
                        let order = Order(
                            id: orderJson["id"] as! Int64 ,
                            status: orderJson["status"] as! String,
                            lines: lines)
                        
                        orders.append(order)
                    }
                }
            }
            tableView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    // может быть сгруппировать по статусу
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath)

        cell.textLabel?.text = orders[indexPath.row].status
        cell.detailTextLabel?.text = String(orders[indexPath.row].id)


        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let orderId = orders[indexPath.row].id
            requestOrderCancel(orderId)
        }
        
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
        
        if let vc = segue.destination as? OrderListLinesVC {
            vc.lines = orders[(tableView.indexPathForSelectedRow?.row)!].lines
        }
    }
}

struct Order {
    var id: Int64
    //var address: String
    var status: String
    var lines: [Line] = []
    
    struct Line {
        var item: String
        var qty: Int64
    }
}
