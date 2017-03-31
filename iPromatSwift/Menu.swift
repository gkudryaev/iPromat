//
//  Menu.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 15.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class Menu: UITableViewController {
    
    @IBAction func logoutPressed(_ sender: Any) {
        userData.logout()
        AppModule.sharedInstance.goStoreBoard(storeBoardName: "Logon")
    }
    
    @IBAction func backPressed(_ sender: Any) {
        let nc = navigationController as! MenuNC
        UIApplication.shared.keyWindow?.rootViewController = nc.ncOrigin
    }
    
    @IBAction func saveOption(segue:UIStoryboardSegue) {
        
        for vc in segue.source.childViewControllers {
            if let vc = vc as? Profile {
                userData.name = vc.nameTxt.text ?? ""
                userData.fname = vc.fnameTxt.text ?? ""
                userData.lname = vc.lnameTxt.text ?? ""
                userData.email = vc.emailTxt.text ?? ""
                userData.phone = vc.phoneTxt.text ?? ""
                userData.address = vc.addressTxt.text ?? ""
                userData.floor = vc.floorTxt.text ?? ""
                userData.is_elevator = vc.isElevator.isOn ? "1" : "0"
                userData.save()
                requestUpdateProfile()
            }
        }
    }
    func requestUpdateProfile () {
        JsonHelper.request(.profileUpdate,
                           ["id":userData.id,
                            "name":userData.name,
                            "fname":userData.fname,
                            "lname":userData.lname,
                            "email":userData.email,
                            "phone":userData.phone,
                            "address":userData.address,
                            "floor":userData.floor,
                            "is_elevator":userData.is_elevator
                            ],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseUpdateProfile(json: json, error: error)
        })
    }
    func responseUpdateProfile (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            
        }
    }

    @IBAction func cancelOption(segue:UIStoryboardSegue) {
    }
    
    
    

}
