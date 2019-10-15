//
//  Animal+CoreDataProperties.swift
//  PersistenciaCoreData
//
//  Created by Lucas Costa  on 22/07/19.
//  Copyright © 2019 LucasCosta. All rights reserved.
//
//

import Foundation
import CoreData

extension Animal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Animal> {
        return NSFetchRequest<Animal>(entityName: "Animal")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var color: NSObject?
    @NSManaged public var id: UUID?

}
