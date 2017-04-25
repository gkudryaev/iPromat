//
//  Model.swift
//  iPromatSwift
//
//  Created by Grisha on 4/21/17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation


class Order {
    let id: Int64
    let status: Status
    let address: String
    let lines: [OrderLine]
    
    var suppliers: [String] = []
    var supplierLines: [[OrderLine]] = []
    var supplierRatings: [String: Int64] = [:]
    var supplierDelivery: [String: Int64] = [:]
    
    var cost: Int64 {
        var cost: Int64 = 0
        for line in lines {
            if let price = line.price {
                cost +=  price
            }
        }
        cost = cost + delivery
        return cost
    }
    
    var delivery: Int64 {
        var delivery: Int64 = 0
        for (_, val) in supplierDelivery {
            delivery += val
        }
        return delivery
    }
    
    init? (json: [String: Any]) {
        
        guard let id = json["id"] as? Int64,
            let status = json["status"] as? String,
            let address = json["address"] as? String,
            let linesJson = json["lines"] as? [[String:Any]],
            let ratingsJson = json["ratings"] as? [[String:Any]],
            let deliveriesJson = json["delivery"] as? [[String:Any]]
            else {return nil}
    
        let lines: [OrderLine] = OrderLine.lines(json: linesJson)
        
        for line in lines {
            if let ind = suppliers.index(of: line.supplier) {
                supplierLines[ind].append(line)
            } else {
                suppliers.append(line.supplier)
                supplierLines.append([line])
            }
        }
        
        for ratingJson in ratingsJson {
            if let supplier = ratingJson["supplier"] as? String,
                let rating = ratingJson["rating"] as? Int64 {
                supplierRatings [supplier] = rating
            }
        }

        for deliveryJson in deliveriesJson {
            if let supplier = deliveryJson["supplier"] as? String,
                let delivery = deliveryJson["delivery"] as? Int64 {
                supplierDelivery [supplier] = delivery
            }
        }
        
        self.id = id
        self.status = Status(rawValue: status)!
        self.address = address
        self.lines = lines
        
        
        
    }
    
    static func orders (json: [Any]) -> ([Order.Status], [[Order]]) {
        
        var statuses: [Status] = []
        var statusOrders: [[Order]] = []
        
        for orderJson in json {
            if let orderJson = orderJson as? [String:Any] {
                if let order = Order (json: orderJson) {
                    if let ind = statuses.index(of: order.status) {
                        statusOrders[ind].append(order)
                    } else {
                        statuses.append(order.status)
                        statusOrders.append([order])
                    }
                }
            }
        }
        return (statuses, statusOrders)
    }
    

    enum Status: String {
        case NEW, BIDDING, FIRST_BID, EXECUTING, DELIVERED, CANCEL_SPL, CANCEL_CST
        var name: String {
            switch self {
            case .NEW:
                return "Зарегистрирован"
            case .BIDDING:
                return "Передан в обработку"
            case .FIRST_BID:
                return "Предложена цена"
            case .EXECUTING:
                return "Выбран поставщик"
            case .DELIVERED:
                return "Доставлено"
            case .CANCEL_SPL:
                return "Отменен поставщиком"
            case .CANCEL_CST:
                return "Отменен заказчиком"
            }
        }
    }
    
}

// Nested - не очень красивый код получается - нельзя вынести init в extension
class OrderLine {
    let item: Catalog.Item
    let qty: Int64
    let price: Int64?
    let supplier: String
    
    init? (json: [String: Any]) {
        guard let itemId = json ["item"] as? Int64,
            let item = catalog?.items[itemId] ,
            let qty = json ["qty"] as? Int64,
            let supplier = json ["supplier"] as? String
            else {return nil}
        let price = json ["price"] as? Int64
        
        self.item = item
        self.qty = qty
        self.supplier = supplier
        self.price = price
    }
    
    static func lines (json: [[String: Any]]) -> [OrderLine] {
        var lines: [OrderLine] = []
        for lineJson in json {
            if let line = OrderLine(json: lineJson) {
                lines.append(line)
            }
        }
        return lines
    }
}


