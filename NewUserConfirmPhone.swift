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
                           ["phone":phone!, "code": ConfirmCodeTxt.text!,
                            "name":name!, "email": email!,
                            "status": "NEW"],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseCheckPhoneCode(json: json, error: error)
        })
    }
    
    func responseCheckPhoneCode (json: [String: Any]?, error: String?) {
        
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            userData.save(json: json!)
            AppModule.sharedInstance.goStoreBoard(storeBoardName: "Catalog")
        }
    }
    
    
}
