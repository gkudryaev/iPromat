//
//  NewOrderVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 28.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewOrderVC: UIViewController {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    var newOrderPC: NewOrderPC?
    
    @IBAction func continuePressed(_ sender: Any) {
        if let vc = newOrderPC {
            vc.nextPage()
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        AppModule.sharedInstance.goStoreBoard(storeBoardName: "Catalog")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? NewOrderPC {
            newOrderPC = vc
            newOrderPC?.delegateOrder = self
        }
    }
    
}

extension NewOrderVC: NewOrderPCDelegate {
    func didNewViewController(_ viewController: UIViewController) {
        
        continueBtn.setTitle("Продолжить", for: .normal)
        
        switch viewController {
        case _ as NewOrderConfirmVC:
            continueBtn.setTitle("Подтвердить", for: .normal)
            headerLbl.text = "Подтверждение"
        case _ as NewOrderAddressVC:
            headerLbl.text = "Адрес"
        case _ as NewOrderDateVC:
            headerLbl.text = "Дата доставки"
        case _ as NewOrderCommentVC:
            headerLbl.text = "Дополнительно"
        default: break
        }
    }
}
