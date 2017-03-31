//
//  LogonEmail.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 01.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class LogonAccount: UITableViewController {
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPass: UITextField!

    @IBOutlet weak var phoneTxt: UITextField!
    
    @IBAction func loginEmail(_ sender: AnyObject) {
        
        if let phone = phoneTxt.text, phone.characters.count>1 {
            if phone.characters.count < 7 {
                AppModule.sharedInstance.alertError("Неверный номер телефона", view: self)
            } else {
                requestCheckPhone()
            }
        } else {
            requestLoginEmail()
        }
    }
    
    func requestLoginEmail () {
        JsonHelper.request(.login,
                           ["email":txtEmail.text!, "pass":txtPass.text!],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseLoginEmail(json: json, error: error)
        })
    }

    
    func responseLoginEmail (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        }
        if let json = json {
            userData.save(json: json)
            AppModule.sharedInstance.goStoreBoard(storeBoardName: "Catalog")
        }
    }

    func requestCheckPhone () {
        JsonHelper.request(.checkPhone,
                           ["phone":phoneTxt.text!],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseCheckPhone(json: json, error: error)
        })
    }
    func responseCheckPhone (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            self.performSegue(withIdentifier: "confirmPhoneCode", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? LogonAccountConfirmCode {
            vc.phone = phoneTxt.text
        }
    }

}
