//
//  ItemManager.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/21/21.
//

import Foundation
import CoreData

struct ItemManager
{
    private let _itemDataRepository = ItemDataRepository()

    func createItem(item: Item) {
        _itemDataRepository.create(item: item)
    }

    func fetchItem() -> [Item]? {
        return _itemDataRepository.getAll()
    }
    
    func deleteItem(id: String) -> Bool {
        return _itemDataRepository.delete(id: id)
    }
    func getItems(_ offset: Int)->[Item]?{
        return _itemDataRepository.getItems(offset)
    }
    func fetchItem(ByIdentifer id: String) -> Item?
    {
        return _itemDataRepository.get(byIdentifier: id)
    }


}
