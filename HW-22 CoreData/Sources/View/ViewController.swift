//
//  ViewController.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 15.11.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var names = ["John", "Miki", "Bob"]
    
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
        return tableView
    }()
    
    @objc private func buttonPressed() {
        
        if textField.text == "" {
            showAlert()
        } else {
            names.append(textField.text ?? "yo")
            self.textField.text = ""
        }
        tableView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Пустое поле!",
            message: "Пожалуйста введите имя и фамилию",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
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

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        cell.backgroundColor = .white
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            names.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}
