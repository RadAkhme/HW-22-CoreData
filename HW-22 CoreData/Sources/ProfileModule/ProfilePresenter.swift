//
//  ProfilePresenter.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 19.02.2023.
//

import Foundation


protocol ProfileViewProtocol: AnyObject {
    func setupProfileView(person: Person?)
}

protocol ProfilePresenterProtocol: AnyObject {
    init(view: ProfileViewProtocol, person: Person?)
    
    func savePerson(name: String?, birthDate: Date?, gender: String?, image: Data?)
    func setData()
}


class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    var person: Person?
    
    required init(view: ProfileViewProtocol, person: Person?) {
        self.view = view
        self.person = person
    }
    
    func savePerson(name: String?, birthDate: Date?, gender: String?, image: Data?) {
        person?.name = name
        person?.birthDate = birthDate
        person?.gender = gender
        person?.image = image
        CoreDataManager.instanse.saveContext()
    }
    
    func setData() {
        view?.setupProfileView(person: person)
    }
}
