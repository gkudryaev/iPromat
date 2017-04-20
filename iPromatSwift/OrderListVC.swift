//
//  OrderListVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 29.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class OrderListVC: UITableViewController {
    
    var ord: [String:[Order]] = [:]
    var ordArray: [[Order]] = []

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
            ord.removeAll()
            ordArray.removeAll()
            if let ordersJson = json? ["orders"] as? [Any] {
                for orderJson in ordersJson {
                    if let orderJson = orderJson as? [String: Any] {
                        
                        var lines: [Order.Line] = []
                        if let linesJson = orderJson["lines"] as? [Any] {
                            for lineJson in linesJson {
                                if let lineJson = lineJson as? [String: Any] {
                                    lines.append(Order.Line(
                                        item: lineJson["item"] as! String,
                                        qty: lineJson["qty"] as! Int64,
                                        supplier: lineJson["supplier"] as! String,
                                        price: lineJson["price"] as! Int64
                                    ))
                                }
                            }
                        }
                        
                        var supplierRating: [String: Int64] = [:]
                        if let ratingsJson = orderJson["ratings"] as? [Any] {
                            for ratingJson in ratingsJson {
                                if let ratingJson = ratingJson as? [String: Any] {
                                    supplierRating [ratingJson["supplier"] as! String] = ratingJson["rating"] as? Int64
                                }
                            }
                        }
                        let order = Order(
                            id: orderJson["id"] as! Int64 ,
                            status: orderJson["status"] as! String,
                            address: orderJson["address"] as! String,
                            lines: lines,
                            supplierRating: supplierRating)
                        
                        let status = orderJson["status"] as! String
                        
                        var orderStatus = ord[status] ?? []
                        orderStatus.append(order)
                        ord [status] = orderStatus
                        
                    }
                }
            }
            for status in ord.keys {
                ordArray.append(ord[status]!)
            }
            tableView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ordArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordArray[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath)

        let order = (ordArray[indexPath.section]) [indexPath.row]
        cell.textLabel?.text = order.lines.first?.item
        if order.lines.count>1 {
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
            let orderId = ordArray[indexPath.section][indexPath.row].id
            requestOrderCancel(orderId)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ordArray[section][0].status
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
      
     /*
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.red
        return vw
    }
    */
    
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
            let indexPath = tableView.indexPathForSelectedRow
            vc.order = ordArray[(indexPath?.section)!][(indexPath?.row)!]
        }
    }
}

struct Order {
    var id: Int64
    var status: String
    var address: String
    var lines: [Line] = []
    var supplierRating: [String: Int64] = [:]
    //var delivery: Int64
    
    struct Line {
        var item: String
        var qty: Int64
        var supplier: String
        var price: Int64
    }
}
