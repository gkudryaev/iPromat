//
//  Logon.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 05.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class Logon: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userData.isRegistered() {
            AppModule.sharedInstance.goStoreBoard(storeBoardName: "Catalog")
        }
    }

    
    @IBAction func loginFB(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    //self.returnUserData()
                    //fbLoginManager.logOut()
                    self.showUserData()
                }
            }
        })
        
    }
    
    func showUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, gender, first_name, last_name, locale, email"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                if let result = result as? [String: Any] {
                    if let id = result["id"] as? String {
                        userData.fid = id
                    }
                    if let email = result["email"] as? String {
                        userData.email = email
                    }
                    if let fname = result["first_name"] as? String {
                        userData.fname = fname
                    }
                    if let name = result["last_name"] as? String {
                        userData.name = name
                    }
                    
                    //seguePhoneConfirm
                    self.performSegue(withIdentifier: "confirmPhone", sender: self)
                    
                    
                }
            }
        })
    }
}
