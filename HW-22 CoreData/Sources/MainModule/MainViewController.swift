//
//  ViewController.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 15.11.2022.
//

import UIKit
import SnapKit
import CoreData


class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol?
    
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
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBrown
        setupHierarchy()
        setupLayout()
        presenter = MainPresenter(view: self)
        presenter?.fetchPersons()
    }
    
    // MARK: - Setup
    
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
    
    // MARK: - Actions
    
    @objc private func buttonPressed() {
        if textField.text == "" {
            showAlert()
        } else {
            presenter?.addPerson(name: textField.text ?? "")
            self.textField.text = ""
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Пустое поле!",
                                      message: "Пожалуйста введите имя и фамилию",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true)
    }
}


extension MainViewController: MainViewProtocol {
    func reloadTable() {
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.peopleCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = presenter?.getPersonName(index: indexPath)
        cell.backgroundColor = .white
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deletePerson(index: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let person = presenter?.people?[indexPath.row] else { return }
        let profileController = ModuleBuilder.createProfileModule(person: person)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
