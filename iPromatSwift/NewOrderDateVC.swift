//
//  NewOrderDateVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 24.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewOrderDateVC: UITableViewController {
    
    @IBOutlet weak var datePickerView: UIPickerView!
    @IBOutlet weak var timePickerView: UIPickerView!
    
    
    @IBOutlet weak var dateField: UITextField!
    
    var datePicker: UIDatePicker?
    
    let timeRange = ["08:00 - 14:00",
                     "12:00 - 18:00",
                     "16:00 - 22:00"]
    
    let dateRange: [String] = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var dateRange: [String] = []
        var dat = Date()
        for i in 1...14 {
            dateRange.append(dateFormatter.string(from: dat))
            dat = dat.addingTimeInterval(86400)
        }
        return dateRange
    }()
    
    
    @IBAction func dateEditingBegin(_ sender: Any) {
        
        datePicker = UIDatePicker(frame:CGRect(x:0, y:0, width:self.view.frame.size.width, height:216))
        datePicker?.backgroundColor = UIColor.white
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = Date ()
        datePicker?.maximumDate = Date ().addingTimeInterval(86400*14)
        
        dateField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(NewOrderDateVC.dateSelected))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(NewOrderDateVC.dateCancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        dateField.inputAccessoryView = toolBar
    }
    func dateSelected () {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd.MM.yyyy"
        //dateFormatter.timeStyle = .none
        dateField.text = dateFormatter.string(from: (datePicker?.date)!)
        dateField.resignFirstResponder()
    }
    func dateCancel () {
        dateField.resignFirstResponder()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.dataSource = self
        datePickerView.dataSource = self
        timePickerView.delegate = self
        datePickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }


}

extension NewOrderDateVC: UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == timePickerView {
            return timeRange.count
        } else {
            return dateRange.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == timePickerView {
            return timeRange[row]
        } else {
            return dateRange[row]
        }
    }
}

extension NewOrderDateVC: UIPickerViewDelegate {
    
}
