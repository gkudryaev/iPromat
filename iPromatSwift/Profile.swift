//
//  Profile.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 15.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit


class Profile: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var fnameTxt: UITextField!
    @IBOutlet weak var lnameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var floorTxt: UITextField!
    @IBOutlet weak var isElevator: UISwitch!
    
    func updateFields () {
        nameTxt.text = userData.name
        fnameTxt.text = userData.fname
        lnameTxt.text = userData.lname
        phoneTxt.text = userData.phone
        emailTxt.text = userData.email
        addressTxt.text = userData.address
        floorTxt.text = userData.floor
        
        isElevator.isOn = (userData.is_elevator == "1")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestProfile()
        
        floorTxt.delegate = self
        updateFields()
    }
    
    func requestProfile () {
        JsonHelper.request(.profile,
                           ["id":userData.id],
                           self,
                           {(json: [String: Any]?, error: String?) -> Void in
                            self.responseProfile(json: json, error: error)
        })
    }
    func responseProfile (json: [String: Any]?, error: String?) {
        if let error = error {
            AppModule.sharedInstance.alertError(error, view: self)
        } else {
            userData.save(json: json!)
            updateFields()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool{
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }

}
