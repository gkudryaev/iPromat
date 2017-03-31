//
//  OrderEntity+CoreDataProperties.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 22.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation
import CoreData


extension OrderEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderEntity> {
        return NSFetchRequest<OrderEntity>(entityName: "OrderEntity");
    }

    @NSManaged public var itemId: Int64
    @NSManaged public var itemName: String?
    @NSManaged public var itemImage: String?
    @NSManaged public var qty: Int64
    @NSManaged public var price: Int64
    @NSManaged public var item: ItemEntity?

}
