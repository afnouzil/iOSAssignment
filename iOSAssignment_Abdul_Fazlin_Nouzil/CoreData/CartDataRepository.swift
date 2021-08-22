//
//  CartDataRepository.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/21/21.
//

import Foundation
import CoreData

protocol CartRepository {

    func create(item: Item)
    func getAll() -> [Item]?
    func delete(id: String) -> Bool

}


struct CartDataRepository : CartRepository
{
    func create(item: Item) {

        let cdItem = CDCart(context: PersistentStorage.shared.context)
        cdItem.id = item.id
        cdItem.name = item.name
        cdItem.desc = item.description
        cdItem.price = item.price
        cdItem.image = item.image

        PersistentStorage.shared.saveContext()

    }

    func getAll() -> [Item]? {

        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDCart.self)

        var items : [Item] = []

        result?.forEach({ (cdItem) in
            items.append(cdItem.convertToCart())
        })

        return items
    }
    
    func delete(id: String) -> Bool {

        let cdItem = getCDCartItem(byIdentifier: id)
        guard cdItem != nil else {return false}

        PersistentStorage.shared.context.delete(cdItem!)
        PersistentStorage.shared.saveContext()
        return true
    }
    
    private func getCDCartItem(byIdentifier id: String) -> CDCart?
    {
        let fetchRequest = NSFetchRequest<CDCart>(entityName: "CDCart")
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else {return nil}

            return result

        } catch let error {
            debugPrint(error)
        }

        return nil
    }
    
    func get(byIdentifier id: String) -> Bool {

        let result = getCDCartItem(byIdentifier: id)
        guard result != nil else {return false}
        return true
    }

}
