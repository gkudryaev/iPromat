//
//  LogonConfirmPhone.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 05.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class LogonConfirmPhone: UIViewController {
    
    @IBOutlet weak var phoneTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func confirmPressed(_ sender: Any) {
        
        if ((phoneTxt.text?.characters.count)! > 6) {
            //JsonHelper.sendSMS(phone: phoneTxt.text!, text: "iPromat:kod%20podtverzdenija%2012345")
            requestCheckPhone()
        } else {
            AppModule.sharedInstance.alertError("Неверный номер телефона", view: self)
        }
        
    }

    
    func requestCheckPhone () {
        JsonHelper.request(.checkPhone,
                           ["phone":phoneTxt.text!, "status": "NEW",
                            "fid": userData.fid],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseCheckPhone(json: json, error: error)
                            
        })
    }
    
    func responseCheckPhone (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            self.performSegue(withIdentifier: "fbConfirmPhoneCode", sender: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? LogonConfirmVC {
            vc.phone = phoneTxt.text!
        }
    }
}


