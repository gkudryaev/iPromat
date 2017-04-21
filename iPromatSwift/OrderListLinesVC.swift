//
//  OrderListLinesVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 29.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class OrderListLinesVC: UITableViewController {
    
    var order: Order!
    
   

    @IBAction func cancelRatingSupplier(segue:UIStoryboardSegue) {
        print ("cancel")
    }
    @IBAction func doneRatingSupplier(segue:UIStoryboardSegue) {
        guard let vc = segue.source as? SupplierRatingVC else {return}
        order.supplierRatings[vc.supplier!] = vc.rating
        requestRateSupplier (supplier: vc.supplier!, rating: vc.rating!)
    }
    
    func requestRateSupplier (supplier: String, rating: Int64) {
        JsonHelper.request(.rateSupplier,
                           ["id":userData.id,
                            "order":order.id,
                            "supplier":supplier,
                            "rating":rating,
                            ],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseRateSupplier(json: json, error: error)
        })
    }
    func responseRateSupplier (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //header and line's count
        return order.suppliers.count + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 0 : order.supplierLines[section-1].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "line", for: indexPath) as! OrderListLinesCell
            
            let line =  order.supplierLines[indexPath.section-1][indexPath.row]
            cell.name.text = line.item
            cell.quantity.text = "Кол-во: \(line.qty)"
            if let price = line.price, price != 0 {
                cell.price.text = "Стоимость: \(String(price))"
            } else {
                cell.price.text = "Цена не сформирована"
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! OrderListLinesCell
            
            let line =  order.supplierLines[indexPath.section-1][indexPath.row]
            cell.orderCost.text = line.item
            cell.orderDelivery.text = "Кол-во: \(order)"
            
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if section == 0 {
            return UIView()
        }
        
        navigationItem.title = "Заказ \(String(order.id))"
        navigationController?.title = "Заказ \(String(order.id))"

        
        let view = UIView()
        let label = UILabel()
        
        view.backgroundColor = AppModule.sectionBkColor
        
        label.text = order.suppliers[section-1]
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = label.font.withSize(15)

        let button   = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Оценить", for: .normal)
        button.titleLabel!.font = UIFont (name: button.titleLabel!.font.fontName, size: 13)
        button.setTitle(order.suppliers[section-1], for: .reserved)
        
        if order.suppliers[section-1] != "Поставщик не определен" {
            button.addTarget(self, action: #selector(OrderListLinesVC.rateSupplier(sender:)), for:.touchUpInside)
            button.setTitleColor(UIColor.blue, for: .normal)
        } else {
            button.setTitleColor(UIColor.gray, for: .normal)
        }
        
        let views = ["label": label,"button":button,"view": view]
        view.addSubview(label)
        view.addSubview(button)
        let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-5-[button(70)]-|", options: .alignAllCenterY, metrics: nil, views: views)
        view.addConstraints(horizontallayoutContraints)
        
        let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalLayoutContraint)
        
        return view
    }
    
    func rateSupplier (sender:UIButton!) {
        performSegue(withIdentifier: "rateSupplier", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SupplierRatingVC {
            if let button = sender as? UIButton {
                guard let supplier = button.title(for: .reserved) else {return}
                vc.supplier = supplier
                guard let rating = order.supplierRatings[supplier] else {return}
                vc.rating = rating
            }
        }
    }
 
}
