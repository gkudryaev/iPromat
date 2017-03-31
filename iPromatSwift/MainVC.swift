//
//  MainVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 23.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    @IBAction func pressedButton(_ sender: AnyObject) {
        var userData = UserData()
        userData.email = "privet"
        userData.save()
        var ud = UserData()
        ud.load()
        print (ud.email)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
