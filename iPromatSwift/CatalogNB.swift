//
//  CatalogNB.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 14.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class CatalogNB: UINavigationBar, UITextFieldDelegate {

    var viewNavigationBar: UIView?
    var menuButton: UIButton?
    var textSearch: UITextField?
    var shopButton: UIButton?
    var cartCount: UILabel?
    var navigationController: UINavigationController?
    
    func addConsView (_ fmt: String) -> [NSLayoutConstraint] {
        let views = ["view" : viewNavigationBar!]
        return NSLayoutConstraint.constraints(withVisualFormat: fmt, options:[] , metrics: nil, views: views)
    }
    func addConsButtons (_ fmt: String) -> [NSLayoutConstraint] {
        let views = ["menuButton" : menuButton!, "textSearch": textSearch!, "shopButton": shopButton!, "cartCount": cartCount!] as [String : Any]
        return NSLayoutConstraint.constraints(withVisualFormat: fmt, options:[] , metrics: nil, views: views)
    }
    func showCustomNavigation () {
        
        viewNavigationBar = UIView()
        viewNavigationBar!.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(viewNavigationBar!)
        
        var cons: [NSLayoutConstraint]
        cons = addConsView ("H:|-30-[view]-|")
        cons += addConsView ("V:|-0-[view]-0-|")
        
        viewNavigationBar?.addSubview(menuButton!)
        viewNavigationBar?.addSubview(textSearch!)
        viewNavigationBar?.addSubview(shopButton!)
        viewNavigationBar?.addSubview(cartCount!)
        
        cons += addConsButtons("H:|-0-[menuButton(40)]-[textSearch]-[shopButton(40)]|")
        cons += addConsButtons("V:|-1-[menuButton(40)]")
        cons += addConsButtons("V:|-1-[textSearch(40)]")
        cons += addConsButtons("V:|-1-[shopButton(40)]")

        cons += addConsButtons("H:[textSearch]-3-[cartCount(20)]")
        cons += addConsButtons("V:|-0-[cartCount(20)]")

        NSLayoutConstraint.activate(cons)
                
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.menuButton = UIButton()
        menuButton!.setImage(UIImage(named: "iconMenu"), for: UIControlState())
        menuButton?.translatesAutoresizingMaskIntoConstraints = false

        self.shopButton = UIButton()
        shopButton!.setImage(UIImage(named: "iconShopping"), for: UIControlState())
        shopButton?.translatesAutoresizingMaskIntoConstraints = false

        let searchIcon = UIImageView (image: UIImage(named: "iconSearch"))
        textSearch = UITextField()
        textSearch?.borderStyle = .none
        textSearch?.backgroundColor = UIColor.clear
        textSearch?.textColor = UIColor.white
        textSearch?.keyboardType = .webSearch
        textSearch?.clearButtonMode = .whileEditing
        textSearch?.autocorrectionType = .no
        textSearch?.leftViewMode = .always
        textSearch?.leftView = searchIcon
        textSearch?.placeholder = "Поиск"
        textSearch?.translatesAutoresizingMaskIntoConstraints = false
        
        cartCount = UILabel()
        cartCount?.font.withSize(10)
        cartCount?.layer.borderColor = AppModule.defaultColor.cgColor
        cartCount?.layer.borderWidth = 1
        cartCount?.layer.cornerRadius = 10
        cartCount?.clipsToBounds = true
        cartCount?.backgroundColor = UIColor.white
        cartCount?.textColor = AppModule.defaultColor
        cartCount?.textAlignment = .center
        cartCount?.minimumScaleFactor = 0.5
        cartCount?.translatesAutoresizingMaskIntoConstraints = false
        setQty()
        
        shopButton?.addTarget(self, action: #selector(CatalogNB.shopButtonPressed(sender:)), for: .touchUpInside)
        
        menuButton?.addTarget(self, action: #selector(CatalogNB.menuButtonPressed(sender:)), for: .touchUpInside)
        
        self.showCustomNavigation()
        
        textSearch?.delegate = self
    }
    
    func menuButtonPressed (sender:UIButton!) {

        let storyBoard = UIStoryboard.init(name: "Menu", bundle: nil)
        let vc = storyBoard.instantiateInitialViewController() as! MenuNC
        vc.ncOrigin = navigationController
        UIApplication.shared.keyWindow?.rootViewController = vc
        
        /*
        let storyBoard = UIStoryboard.init(name: "Menu", bundle: nil)
        let vc = storyBoard.instantiateInitialViewController()
        navigationController?.topViewController?.present(vc!, animated: true, completion: nil)
 */

    }
    
    func shopButtonPressed(sender:UIButton!)
    {
        if cartCount?.text == "" {
            return
        }
        let storyBoard = UIStoryboard.init(name: "Cart", bundle: nil)
        let vc = storyBoard.instantiateInitialViewController() as! CartNC
        vc.ncOrigin = navigationController
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    
    func setQty (){
        let cnt = CoreDataManager.instance.fetchOrders()?.count
        var s: String
        //не переходим если корзина пустая
        if cnt == 0 {
            s = ""
            cartCount?.isHidden = true
        } else {
            s = "\(cnt!)"
            cartCount?.isHidden = false
        }
        cartCount?.text = s
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let nc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if nc.viewControllers [0] is Category{
                nc.viewControllers [0].performSegue(withIdentifier: "catalogSearch", sender: nil)
            }
        }
 
        return false
    }
    

}
