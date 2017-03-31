//
//  NewUserConfirmPhone.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 15.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewUserConfirmPhone: UITableViewController {

    @IBOutlet weak var ConfirmCodeTxt: UITextField!
    
    var phone: String?
    var name: String?
    var email: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func confirmPressed(_ sender: Any) {

        requestCheckPhoneCode()
    }

    func requestCheckPhoneCode () {
        JsonHelper.request(.checkPhoneCode,
                           ["phone":phone!, "code": ConfirmCodeTxt.text!],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseCheckPhoneCode(json: json, error: error)
        })
    }
    
    func responseCheckPhoneCode (json: [String: Any]?, error: String?) {
        
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            requestNewCustomer()
        }
    }
    
    
    func requestNewCustomer () {
        JsonHelper.request(.newCustomer,
                           ["phone":phone!, "name":name!, "email": email!],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseNewCustomer(json: json, error: error)
        })
    }
    func responseNewCustomer (json: [String: Any]?, error: String?) {
        
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            userData.save(json: json!)
            AppModule.sharedInstance.goStoreBoard(storeBoardName: "Catalog")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
