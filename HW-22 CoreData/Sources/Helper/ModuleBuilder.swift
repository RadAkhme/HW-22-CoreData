//
//  ModuleBuilder.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 23.02.2023.
//

import UIKit


protocol BuilderProtocol {
    static func createMainModule() -> UIViewController
    static func createProfileModule(person: Person) -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view)
        view.presenter = presenter
        
        return view
    }
    
    static func createProfileModule(person: Person) -> UIViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter(view: view, person: person)
        view.presenter = presenter
        
        return view
    }
}
