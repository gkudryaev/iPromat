//
//  LogonConfirmVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 08.02.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class LogonConfirmVC: UIViewController {
    
    var phone: String = ""
    var params = [String:String]()

    @IBOutlet weak var codeTextField: UITextField!
    
    @IBAction func confirmPressed(_ sender: AnyObject) {
        requestCheckPhoneCode()
    }

    func requestCheckPhoneCode () {
        JsonHelper.request(.checkPhoneCode,
                           ["phone":phone, "code": codeTextField.text!],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseCheckPhoneCode(json: json, error: error)
        })
    }
    
    func responseCheckPhoneCode (json: [String: Any]?, error: String?) {
        
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        }
        if let json = json {
            userData.phone = phone
            requestLogin()
        }
    }

    
    func requestLogin () {
        JsonHelper.request(.login,
                           ["phone": userData.phone,
                            "email": userData.email,
                            "fid": userData.fid,
                            "fname": userData.fname,
                            "name": userData.name ],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseLogin(json: json, error: error)
        })
    }
    
    func responseLogin (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            if let json = json {
                userData.save(json: json)
                AppModule.sharedInstance.goStoreBoard(storeBoardName: "Catalog")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        params = [String:String]()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
