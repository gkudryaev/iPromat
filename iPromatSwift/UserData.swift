//
//  UserData.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 15.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation

var userData = UserData()

class UserData {
    struct Address {
        var address: String
        var floor: String
        var is_elevator: String
        
        init (_ address: String, _ floor: String, _ is_elevator: String) {
            self.address = address
            self.floor = floor
            self.is_elevator = is_elevator
        }
    }
    
    let keyUserAttributes = "iPromatUserAttributes"
    let keyAddresses = "iPromatAddresses"
    
    var name: String = ""
    var fname: String = ""
    var lname: String = ""

    var email: String = ""
    var phone: String = ""
    var fid: String = ""
    var vk: String = ""
    var id: String = ""
    
    var address: String = ""
    var floor: String = ""
    var is_elevator = ""
    
    var addresses: [Address] = []
    
    func save () {
        let std = UserDefaults.standard
        std.set ([
            "name": name,
            "fname": fname,
            "lname": lname,

            "email": email,
            "phone": phone,
            "fid": fid,
            "vk": vk,
            "id": id,
            
            "address": address,
            "floor": floor,
            "is_elevator": is_elevator
            
            ], forKey: keyUserAttributes)
        
        var adrDict = [String:[String:String]]()
        for (ind, adr) in addresses.enumerated() {
            adrDict [String(ind)] = [
                "address":adr.address,
                "floor": adr.floor,
                "is_elevator": adr.is_elevator
            ]
        }
        std.set (adrDict, forKey: keyAddresses)
    }
    
    func save (json: [String: Any]) {
        name = json ["name"] as? String ?? ""
        fname = json ["fname"] as? String ?? ""
        lname = json ["lanme"] as? String ?? ""

        email = json ["email"] as? String ?? ""
        phone = json ["phone"] as? String ?? ""
        fid = json ["fid"] as? String ?? ""
        vk = json ["vk"] as? String ?? ""
        id = String(format: "%.0f", json ["id"] as? Double ?? -1)
        
        address = json ["address"] as? String ?? ""
        floor = String(format: "%.0f", json ["floor"] as? Double ?? -1)
        if floor == "-1" {
            floor = ""
        }
        is_elevator = json ["is_elevator"] as? String ?? ""

        
        addresses.removeAll()
        if let adrsJson = json ["order_address"] as? [Any] {
            for adrJson in adrsJson {
                if let adrJson = adrJson as? [String: Any] {
                    addresses.append(Address(
                        adrJson["address"] as? String ?? "",
                        String(format: "%.0f", adrJson ["floor"] as? Double ?? -1),
                        adrJson["is_elevator"] as? String ?? ""
                    ))
                    print (adrJson["address"] as? String ?? "")
                }
            }
        }
        
        save()
    }
    
    func load () {
        if let p = UserDefaults.standard.dictionary(forKey: keyUserAttributes) as? [String:String] {
            name = p["name"] ?? ""
            fname = p["fname"] ?? ""
            lname = p["lname"] ?? ""

            email = p["email"] ?? ""
            phone = p["phone"] ?? ""
            fid = p["fid"] ?? ""
            vk = p["vk"] ?? ""
            id = p["id"] ?? ""

            address = p["address"] ?? ""
            floor = p["floor"] ?? ""
            is_elevator = p["is_elevator"] ?? ""
        }
        if let p = UserDefaults.standard.dictionary(forKey: keyAddresses) as? [String:[String:String]] {
            addresses.removeAll()
            for (_, val) in p {
                addresses.append(Address(
                    val["address"] ?? "",
                    val["floor"] ?? "",
                    val["is_elevator"] ?? ""
                ))
            }
        }
    }
    
    func isRegistered () -> Bool{
        load()
        if id == "" {
            return false
        }
        return true
    }
    func logout () {
        UserDefaults.standard.removeObject(forKey: keyUserAttributes)
        id = ""
    }
}

