//
//  LogonAccountConfirmCode.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 15.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class LogonAccountConfirmCode: UITableViewController {
    
    var phone: String?

    @IBOutlet weak var codeTxt: UITextField!
    
    @IBAction func confirmPressed(_ sender: Any) {
        if codeTxt.text == nil {
            AppModule.sharedInstance.alertError("Введите код", view: self)
        } else {
            requestPhoneCode()
        }
    }
    
    func requestPhoneCode () {
        JsonHelper.request(.checkPhoneCode,
                           ["phone":phone!, "code": codeTxt.text!],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.parseResponsePhoneCode(json: json, error: error)
        })
    }
    func parseResponsePhoneCode (json: [String: Any]?, error: String?) {
        
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
