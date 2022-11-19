//
//  ViewController.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 15.11.2022.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    
    var people: [NSManagedObject] = []
    
    // MARK: - Outlets
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "user name"
        textField.textAlignment = .center
        textField.layer.cornerRadius = 20
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Press", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .systemGray5
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    @objc private func buttonPressed() {
        
        if textField.text == "" {
            showAlert()
        } else {
            save(name: textField.text ?? "", key: "name")
            self.textField.text = ""
        }
        tableView.reloadData()
    }
    
    public func save(name: String, key: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext) else { return }
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: key)
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Пустое поле!",
            message: "Пожалуйста введите имя и фамилию",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBrown
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view).offset(40)
            make.right.equalTo(view).inset(40)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(textField.snp.bottom).offset(15)
            make.left.equalTo(view).offset(40)
            make.right.equalTo(view).inset(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(20)
            make.right.bottom.left.equalTo(view)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = person.value(forKey: "name") as? String
        cell.backgroundColor = .white
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        if editingStyle == .delete {
            tableView.beginUpdates()
            managedContext.delete(people.remove(at: indexPath.row))
            try? managedContext.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ProfileViewController()
        tableView.deselectRow(at: indexPath, animated: true)
        viewController.names = people[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
