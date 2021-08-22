//
//  CDCart+CoreDataProperties.swift
//  iOSAssignment_Abdul_Fazlin_Nouzil
//
//  Created by Abdul Fazlin Nouzil on 8/21/21.
//
//

import Foundation
import CoreData


extension CDCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCart> {
        return NSFetchRequest<CDCart>(entityName: "CDCart")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    func convertToCart() -> Item
    {
        return(Item(id: self.id!, name: self.name!, image: self.image!, description: self.desc!, price: self.price!))
    }


}

extension CDCart : Identifiable {

}
