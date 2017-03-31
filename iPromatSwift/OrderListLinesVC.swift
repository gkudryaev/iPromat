//
//  OrderListLinesVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 29.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class OrderListLinesVC: UITableViewController {
    
    var lines: [Order.Line] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "line", for: indexPath)

        cell.textLabel?.text = lines[indexPath.row].item
        cell.detailTextLabel?.text = String (lines [indexPath.row].qty)

        return cell
    }
    
 
}
