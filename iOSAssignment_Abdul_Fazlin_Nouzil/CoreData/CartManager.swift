//
//  CartManager.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/21/21.
//

import Foundation
import CoreData

struct CartManager
{
    private let _cartDataRepository = CartDataRepository()

    func createCartItem(item: Item) {
        _cartDataRepository.create(item: item)
    }

    func fetchItem() -> [Item]? {
        return _cartDataRepository.getAll()
    }
    
    func fetchItem(byIdentifier id: String) -> Bool
    {
        return _cartDataRepository.get(byIdentifier: id)
    }

    func deleteItem(id: String) -> Bool {
        return _cartDataRepository.delete(id: id)
    }
    
}
