//
//  NewUserVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 15.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewUserVC: UITableViewController {
    
    var code: String?

    @IBOutlet weak var NameTxt: UITextField!
    @IBOutlet weak var PhoneTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    
    @IBAction func continuePressed(_ sender: Any) {
        if let name = NameTxt.text, name.characters.count>1 {
        } else {
            AppModule.sharedInstance.alertError("Укажите, пожалуйста, Ваше имя", view: self)
            return
        }
        
        if let phone = PhoneTxt.text, phone.characters.count>7 {
        } else {
            AppModule.sharedInstance.alertError("Неверный номер телефона", view: self)
            return
        }
        //JsonHelper.sendSMS(phone: PhoneTxt.text!, text: "iPromat:kod%20podtverzdenija%2012345")

        requestPhoneCode ()
    }
    
    func requestPhoneCode () {
        JsonHelper.request(.checkPhone,
                           ["phone":PhoneTxt.text!, "email": emailTxt.text!, "status": "NEW"],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responsePhoneCode(json: json, error: error)
        })
    }
    func responsePhoneCode (json: [String: Any]?, error: String?) {
        
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            self.performSegue(withIdentifier: "confirmPhoneCode", sender: nil)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewUserConfirmPhone {
            vc.phone = PhoneTxt.text
            vc.email = emailTxt.text
            vc.name = NameTxt.text
        }
    }
    
}
