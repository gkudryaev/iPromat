//
//  CoreDataManager.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 21.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager ()
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: Storage.shared.context)!
    }

        
    func fetchedResultsController (entityName: String, keyForSort: String) -> NSFetchedResultsController <NSManagedObject> {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: entityName)
        let sortDescriptor = NSSortDescriptor (key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let moc = Storage.shared.context
        let fetchedRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedRC
    }
    
    func addOrder () {
        
        addOrder (itemId: 100, itemName:"TestTest", itemImage:nil,
                  qty:100)
        
    }
  
    
    
    func addOrder (itemId: Int64,
                   itemName: String?,
                   itemImage: String?,
                   qty: Int64/*,
                   price: Int64*/) {
        
        let entity = entityForName (entityName: "OrderEntity")
        let order = OrderEntity(entity: entity, insertInto: Storage.shared.context)
        order.itemId = itemId
        order.itemName = itemName
        order.itemImage = itemImage
        order.qty = qty
        //order.price = price
        commit()
    }
    
    func commit () {
        do {
            try Storage.shared.context.save()
        } catch {
            print (error)
        }
    }
    
    func delete (object: NSManagedObject) {
        Storage.shared.context.delete(object)
        commit ()
    }
    
    func fetchOrders () -> [NSManagedObject]? {
        
        let moc = Storage.shared.context
        var res: [OrderEntity] = [OrderEntity]()
        
        let request: NSFetchRequest<OrderEntity> = OrderEntity.fetchRequest ()
        do {
            res = try moc.fetch(request)
        } catch {
            print ("\(error)")
        }
        
       return res
        
    }
}
