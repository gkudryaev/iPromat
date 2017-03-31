//
//  Catalog.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 06.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation

var catalog: Catalog?

protocol CatalogDelegate {
    func loaded()
}

class Catalog {
    
    class Item {
        let id: Int
        var name: String
        var vendor: String?
        var image: String?
        var wrapping: String?
        var uom: String?
        var weight: Double?

        init? (json: Any) {
            guard let json = json as? [String: Any]
                else {
                    return nil
            }
            id = (json["id"] as? Int)!
            name = (json["name"] as? String)!
            vendor = json["vendor"] as? String
            image = json["image"] as? String
            wrapping = json["wrapping"] as? String
            uom = json["uom"] as? String
            weight = json["weight"] as? Double
        }

    }
    
    class Category {
        var name: String
        var lvl: Int
        var image: String?
        var subCategory = [Category]()
        var items = [Item]()
        
        init? (json: Any, lvl: Int) {
            
            self.lvl = lvl
            guard let json = json as? [String: Any]
                else {
                    return nil
            }

            name = (json["name"] as? String)!
            image = json["image"] as? String
            
            let subCatNode = "cat_\(lvl+1)"
            if let subcatsJson = json[subCatNode] as? [Any] {
                for catJson in subcatsJson {
                    let cat = Category(json: catJson, lvl: lvl+1)
                    subCategory.append(cat!)
                }
            }
            
            if let itemsJson = json["items"] as? [Any] {
                for itemJson in itemsJson {
                    let item = Item(json: itemJson)
                    items.append(item!)
                }
            }
        }
    }
    
    
    static let sharedInstance = Catalog()
    var categories = [Category] ()
    var delegate: CatalogDelegate?
    
    var lvl1Selected: Category?
    var lvl2Selected: Category?
    var lvl3Selected: Category?
    var itemSelected: Item?
    var itemIndex: Int?

        
    fileprivate init () {
        JsonHelper.request(.catalog,
                           nil,
                           nil
                           ) {(json: [String: Any]?, error: String?) -> Void in
            if let json = json {
                self.parseJson(json)
                if let delegate = self.delegate {
                    delegate.loaded()
                }
            }
        }
    }
    
    fileprivate func parseJson (_ json:[String: Any]) {
        if let catsJson = json ["cat_1"] as? [Any] {
            for catJson in catsJson {
                if let cat = Category(json: catJson, lvl: 1) {
                    self.categories.append(cat)
                }
            }
        }
    }
}
