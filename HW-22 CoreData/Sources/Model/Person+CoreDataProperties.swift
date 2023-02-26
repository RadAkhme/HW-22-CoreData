//
//  Person+CoreDataProperties.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 10.01.2023.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var birthDate: Date?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var image: Data?

}

extension Person : Identifiable {

}
