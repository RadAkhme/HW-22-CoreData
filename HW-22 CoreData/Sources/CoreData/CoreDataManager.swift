//
//  CoreDataManager.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 19.11.2022.
//

import Foundation
import CoreData


class CoreDataManager {
    
    static let instanse = CoreDataManager()
    
    // MARK: - Core Data stack
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HW_22_CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: context) ?? NSEntityDescription()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addPerson(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) ?? NSEntityDescription()
        let person = Person(entity: entity, insertInto: context)
        person.name = name
        saveContext()
    }
    
    func fetchUsers() -> [Person] {
        var people: [Person] = []
        let fetchRequest = Person.fetchRequest() as NSFetchRequest<Person>
        do {
            people = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return people
    }
}
