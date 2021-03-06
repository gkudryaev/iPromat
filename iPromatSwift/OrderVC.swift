//
//  OrderListLinesVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 29.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class OrderVC: UITableViewController {
    
    var order: Order!
    
    var rowCost: Int!
    var rowDelivery: Int!
    var rowConfirm: Int!
    
   

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
                            "order_id":order.id,
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
        
        if section > 0 {
            return order.supplierLines[section-1].count
        } else {
            
            var cnt = 4
            
            if order.cost == 0 {
                cnt = 2
                rowCost = 101
                rowDelivery = 102
            } else {
                rowCost = 1
                rowDelivery = 2
            }
            
            if order.status != .FIRST_BID {
                cnt -= 1
                rowConfirm = 103
            } else {
                rowConfirm = cnt - 1
            }
            return cnt
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "line", for: indexPath) as! OrderCell
            
            let line =  order.supplierLines[indexPath.section-1][indexPath.row]
            cell.name.text = line.item.name
            cell.quantity.text = "Кол-во: \(line.qty)"
            if let price = line.price, price != 0 {
                cell.price.text = "Стоимость: \(String(price))"
            } else {
                cell.price.text = "Еще нет ставок"
            }
            if let image = line.item.image {
                cell.customImage.imageFromUrl(image)
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row != 3 ? "headerLine" : "confirmOrder", for: indexPath) as! OrderCell
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = order.status.name
                cell.detailTextLabel?.text = ""
            case rowCost:
                let cost = String(order.cost)
                if cost != "0" {
                    cell.textLabel?.text = "Общая стоимость"
                    cell.detailTextLabel?.text = cost
                } else {
                    cell.textLabel?.text = "Нет ставок"
                    cell.detailTextLabel?.text = ""
                }
            case rowDelivery:
                let delivery = String(order.delivery)
                if delivery != "0" {
                    cell.textLabel?.text = "В том числе доставка"
                    cell.detailTextLabel?.text = delivery
                } else {
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                }
            case rowConfirm:
                if order.status != Order.Status.FIRST_BID {
                    cell.isHidden = true
                } else {
                    cell.isHidden = false
                }
                cell.vc = self
            default: break
            }
           
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 44 : 88
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = label.font.withSize(15)

        view.addSubview(label)
        view.backgroundColor = AppModule.sectionBkColor
        
        
        if section == 0 {
            let views = ["label": label,"view": view]

            let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-10-|", options: .alignAllCenterY, metrics: nil, views: views)
            view.addConstraints(horizontallayoutContraints)
            
            let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            view.addConstraint(verticalLayoutContraint)
            
            label.text = "ОБЩАЯ ИНФОРМАЦИЯ"
            
            return view
        }
        
        navigationItem.title = "Заказ \(String(order.id))"
        navigationController?.title = "Заказ \(String(order.id))"
        
        label.text = order.suppliers[section-1]

        let button   = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Оценить", for: .normal)
        button.titleLabel!.font = UIFont (name: button.titleLabel!.font.fontName, size: 13)
        button.setTitle(order.suppliers[section-1], for: .reserved)
        
        if order.suppliers[section-1] != "Поставщик не определен" {
            button.addTarget(self, action: #selector(OrderVC.rateSupplier(sender:)), for:.touchUpInside)
            button.setTitleColor(UIColor.blue, for: .normal)
        } else {
            button.setTitleColor(UIColor.gray, for: .normal)
        }
        
        let views = ["label": label,"button":button,"view": view]
        view.addSubview(button)
        let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-5-[button(70)]-|", options: .alignAllCenterY, metrics: nil, views: views)
        view.addConstraints(horizontallayoutContraints)
        
        let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view.addConstraint(verticalLayoutContraint)
        
        return view
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section != 0 {
            return nil
        }
    
        let view = UIView()
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = label.font.withSize(15)
        
        view.addSubview(label)
        view.backgroundColor = AppModule.sectionBkColor
        
        
        let views = ["label": label,"view": view]
        
        let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-10-|", options: .alignAllCenterY, metrics: nil, views: views)
        view.addConstraints(horizontallayoutContraints)
        
        let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(verticalLayoutContraint)
        
        label.text = "СТРОКИ ЗАКАЗА"
        
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
