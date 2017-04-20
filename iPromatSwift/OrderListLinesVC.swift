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
    
    var supplierLines: [String:[Order.Line]] = [:] //строки поставщиков
    var suppliers: [String]! //поставщики
    

    @IBAction func cancelRatingSupplier(segue:UIStoryboardSegue) {
        print ("cancel")
    }
    @IBAction func doneRatingSupplier(segue:UIStoryboardSegue) {
        guard let vc = segue.source as? SupplierRatingVC else {return}
        order.supplierRating[vc.supplier!] = vc.rating
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
        for line in order.lines {
            var lines = supplierLines[line.supplier] ?? []
            lines.append(line)
            supplierLines [line.supplier] = lines
        }
        suppliers = Array(supplierLines.keys)
        //tableView.tint
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return suppliers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return supplierLines[suppliers[section]]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "line", for: indexPath)

        cell.textLabel?.text = order.lines[indexPath.row].item + " (к-во: " + String (order.lines [indexPath.row].qty) + ")"
        cell.detailTextLabel?.text = "" //String (order.lines [indexPath.row].qty)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        navigationItem.title = "Заказ \(String(order.id))"
        navigationController?.title = "Заказ \(String(order.id))"

        
        let view = UIView()
        let label = UILabel()
        
        view.backgroundColor = AppModule.sectionBkColor
        
        label.text = suppliers[section]
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = label.font.withSize(15)

        let button   = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Оценить", for: .normal)
        button.titleLabel!.font = UIFont (name: button.titleLabel!.font.fontName, size: 13)
        button.setTitle(suppliers[section], for: .reserved)
        
        if suppliers[section] != "Поставщик не определен" {
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
                guard let rating = order.supplierRating[supplier] else {return}
                vc.rating = rating
            }
        }
    }
 
}
