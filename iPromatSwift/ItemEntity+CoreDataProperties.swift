//
//  ItemEntity+CoreDataProperties.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 22.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity");
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var categoryId: Int64
    @NSManaged public var weight: Int64
    @NSManaged public var orders: NSOrderedSet?

}

// MARK: Generated accessors for orders
extension ItemEntity {

    @objc(insertObject:inOrdersAtIndex:)
    @NSManaged public func insertIntoOrders(_ value: OrderEntity, at idx: Int)

    @objc(removeObjectFromOrdersAtIndex:)
    @NSManaged public func removeFromOrders(at idx: Int)

    @objc(insertOrders:atIndexes:)
    @NSManaged public func insertIntoOrders(_ values: [OrderEntity], at indexes: NSIndexSet)

    @objc(removeOrdersAtIndexes:)
    @NSManaged public func removeFromOrders(at indexes: NSIndexSet)

    @objc(replaceObjectInOrdersAtIndex:withObject:)
    @NSManaged public func replaceOrders(at idx: Int, with value: OrderEntity)

    @objc(replaceOrdersAtIndexes:withOrders:)
    @NSManaged public func replaceOrders(at indexes: NSIndexSet, with values: [OrderEntity])

    @objc(addOrdersObject:)
    @NSManaged public func addToOrders(_ value: OrderEntity)

    @objc(removeOrdersObject:)
    @NSManaged public func removeFromOrders(_ value: OrderEntity)

    @objc(addOrders:)
    @NSManaged public func addToOrders(_ values: NSOrderedSet)

    @objc(removeOrders:)
    @NSManaged public func removeFromOrders(_ values: NSOrderedSet)

}
