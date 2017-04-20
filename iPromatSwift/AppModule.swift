//
//  AppModule.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 06.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation
import UIKit

//let iPromat = "iPromat"

class AppModule {
    
    static let sharedInstance = AppModule()
    
    static let defaultColor = UIColor (colorLiteralRed:248.0/255.0, green:139.0/255.0, blue:57.0/255.0, alpha:1)
    
    static let sectionBkColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    
    func alertError (_ txtError: String, view: UIViewController) {
        
        let alert = UIAlertController(title: "Ошибка", message: txtError, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //DispatchQueue.main.async 
        //{
            view.present(alert, animated: true, completion: nil)
        //}
        
    }

    func alertMessage (_ txtMessage: String, view: UIViewController) {
        
        let alert = UIAlertController(title: "", message: txtMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        //DispatchQueue.main.async
        //{
        view.present(alert, animated: true, completion: nil)
        //}
        
    }

    func goStoreBoard (storeBoardName: String) {
        let storyBoard = UIStoryboard.init(name: storeBoardName, bundle: nil)
        let vc = storyBoard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    func alertQty (view: UIViewController, handlerView:@escaping (String)->Void, qtyDefault: Int64?)  {
        let alert = UIAlertController(title: "Количество", message: "", preferredStyle: .alert)
        
        alert.addTextField {
            (textField: UITextField!) in
            textField.placeholder = "Укажите количество продукции"
            textField.keyboardType = .decimalPad
            if let qty = qtyDefault {
                textField.text = String(qty)
            }
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
        
            let i = handlerView ((alert.textFields?.first?.text)!)
        }))
            
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        view.present(alert, animated: true, completion: nil)

    }
}

