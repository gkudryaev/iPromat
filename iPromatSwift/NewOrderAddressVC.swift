//
//  NewOrderAddressVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 23.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewOrderAddressVC: UITableViewController {
    
    var address: String?
    var elevator: String?
    var floor: String?

    @IBAction func changeAddress(segue:UIStoryboardSegue) {
        let vc = segue.source
        if let txt = vc.view.viewWithTag(123) as? UITextView {
            address = txt.text
            let ind = IndexPath(row: 0, section: 0)
            tableView.reloadRows(at: [ind], with: .automatic)
        }
        if let txt = vc.view.viewWithTag(123) as? UITextField {
            floor = txt.text
            let ind = IndexPath(row: 2, section: 0)
            tableView.reloadRows(at: [ind], with: .automatic)
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        /*/
        userData.addresses.append(UserData.Address("Красногорск, улица братьев горожанкиных 15, 191 Красногорск, улица братьев горожанкиных 15, 191", "0", "0"))
        userData.addresses.append(UserData.Address("addr2", "0", "0"))
        userData.addresses.append(UserData.Address("addr3", "1", "1"))
        */
        if userData.address != "" {
            address = userData.address
            floor = userData.floor
            elevator = userData.is_elevator
        } else {
            if let addr = userData.addresses.first {
                address = addr.address
                floor = addr.floor
                elevator = addr.is_elevator
            } else {
                address = "Нажмите, чтобы ввести адрес"
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.row, indexPath.section) {
        case (0, 0):
            return 80
        case (_, 0):
            return 44
        default:
            return 48
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "Укажите адрес доставки" : "История адресов"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return userData.addresses.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        


        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Address", for: indexPath) as! NewOrderAdressCell
            cell.addressTxt.text = address
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Elevator", for: indexPath) as! NewOrderAdressCell
            cell.elevatorSwitch.isOn = (elevator == "1")
            return cell
        case (0, 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Floor", for: indexPath) as! NewOrderAdressCell
            cell.floorTxt.text = floor
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath) as! NewOrderAdressCell
            cell.addressTxt.text = userData.addresses[indexPath.row].address
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let addr = userData.addresses[indexPath.row]
            address = addr.address
            elevator = addr.is_elevator
            floor = addr.floor
            let indexes: [IndexPath] = {
                [0, 1, 2].flatMap{IndexPath(row: $0, section: 0)}
            } ()
            
            tableView.reloadRows(at: indexes, with: .automatic)
        }
    }

    /*
 override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
 let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))
 let label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
 label.font = UIFont.systemFontOfSize(14)
 label.text = list.objectAtIndex(indexPath.row) as! String
 view.addSubview(label)
 view.backgroundColor = UIColor.grayColor() // Set your background color
 
 return view
 }*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "addressTextView") {
            let vc = segue.destination
            if let txt = vc.view.viewWithTag(123) as? UITextView {
                txt.text = address
                txt.becomeFirstResponder()
            }
        }
        if (segue.identifier == "floor") {
            let vc = segue.destination
            if let txt = vc.view.viewWithTag(123) as? UITextField {
                txt.text = floor
                txt.becomeFirstResponder()
            }
        }
        
        
    }
    

}
