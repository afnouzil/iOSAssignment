//
//  ItemDataRepository.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/21/21.
//

import Foundation
import CoreData

protocol ItemRepository {

    func create(item: Item)
    func delete(id: String) -> Bool
    func getItems(_ offset: Int)->[Item]?

}


struct ItemDataRepository : ItemRepository
{
    func create(item: Item) {

        let cdItem = CDItem(context: PersistentStorage.shared.context)
        cdItem.id = item.id
        cdItem.name = item.name
        cdItem.desc = item.description
        cdItem.price = item.price
        cdItem.image = item.image

        PersistentStorage.shared.saveContext()

    }

    func getAll() -> [Item]? {

        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDItem.self)

        var items : [Item] = []

        result?.forEach({ (cdItem) in
            items.append(cdItem.convertToItem())
        })

        return items
    }
    
    func get(byIdentifier id: String) -> Item? {

        let result = getCDItem(byIdentifier: id)
        guard result != nil else {return nil}
        return result?.convertToItem()
    }

    
    func delete(id: String) -> Bool {

        let cdEmployee = getCDItem(byIdentifier: id)
        guard cdEmployee != nil else {return false}

        PersistentStorage.shared.context.delete(cdEmployee!)
        PersistentStorage.shared.saveContext()
        return true
    }
    
    func getItems(_ offset: Int)->[Item]?{
        
        var items : [Item] = []

        guard let result = getCDItem(offset) else { return nil}
        result.forEach({ (cdItem) in
            items.append(cdItem.convertToItem())
        })
        return items
    }
    
    private func getCDItem(byIdentifier id: String) -> CDItem?
    {
        let fetchRequest = NSFetchRequest<CDItem>(entityName: "CDItem")
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
    
    private func getCDItem(_ fetchOffSet: Int) -> [CDItem]? {
        let fetchRequest = NSFetchRequest<CDItem>(entityName: "CDItem")
        fetchRequest.fetchLimit = 10
        fetchRequest.fetchOffset = fetchOffSet
        
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest)
            return result

        } catch let error {
            debugPrint(error)
        }
        return nil
    }    
}
