//
//  MainPresenter.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 28.01.2023.
//

import Foundation


protocol MainViewProtocol: AnyObject {
    func reloadTable()
}

protocol MainPresenterProtocol: AnyObject {
    
    var people: [Person]? { get set }
    
    func addPerson(name: String)
    func fetchPersons()
    func peopleCount() -> Int
    func getPersonName(index: IndexPath) -> String
    func deletePerson(index: IndexPath)
}


class MainPresenter: MainPresenterProtocol {
    
    var people: [Person]?
    weak var view: MainViewProtocol?
    var builder: BuilderProtocol?
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    func addPerson(name: String) {
        CoreDataManager.instanse.addPerson(name: name)
        fetchPersons()
    }
    
    func fetchPersons() {
        people = CoreDataManager.instanse.fetchUsers()
        view?.reloadTable()
    }
    
    func peopleCount() -> Int {
        return people?.count ?? 0
    }
    
    func getPersonName(index: IndexPath) -> String {
        people?[index.row].name ?? ""
    }
    
    func deletePerson(index: IndexPath) {
        guard let person = people?[index.row] else { return }
        CoreDataManager.instanse.persistentContainer.viewContext.delete(person)
        try? CoreDataManager.instanse.context.save()
        fetchPersons()
    }
}
