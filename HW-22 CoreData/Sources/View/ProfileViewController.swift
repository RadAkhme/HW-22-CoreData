//
//  ProfileViewController.swift
//  HW-22 CoreData
//
//  Created by Радик Ахметзянов on 16.11.2022.
//

import UIKit
import SnapKit
import CoreData

class ProfileViewController: UIViewController {
    
    var names: NSManagedObject? {
        didSet {
            name.text = names?.value(forKey: "name") as? String
            
        }
    }
    
    let imageArray = [UIImage(named: "male"), UIImage(named: "female")]
    var gender = ["Male", "Female"]
    var people: [NSManagedObject] = []
    // MARK: - Outlets
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var name: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        textField.layer.cornerRadius = 20
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.tintColor = .systemGreen
        picker.isUserInteractionEnabled = false
        return picker
    }()
    
    private lazy var segmentedControll: UISegmentedControl = {
        let segment = UISegmentedControl(items: gender)
        let font = UIFont.systemFont(ofSize: 16)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segment.addTarget(self, action: #selector(selectedValue), for: .valueChanged)
        segment.backgroundColor = .systemGreen
        segment.selectedSegmentTintColor = .systemYellow
//        segment.isUserInteractionEnabled = false
        return segment
    }()
    
    private let birthDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Birth date:"
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        setupNavigationController()
        setupHierarchy()
        setupLayout()
    }
    
    func setupNavigationController() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightButtonItemAction))
        navigationController?.navigationBar.tintColor = UIColor.systemYellow
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
    
    @objc func selectedValue(target: UISegmentedControl) {
        if target == segmentedControll {
            let segmentIndex = target.selectedSegmentIndex
            profileImage.image = imageArray[segmentIndex]
            let genderValue = gender[segmentIndex]
            save(name: genderValue, key: "gender")
        }
    }
    
    @objc func rightButtonItemAction() {
        print("tapped")
    }
    
    private func setupHierarchy() {
        view.addSubview(profileImage)
        view.addSubview(name)
        view.addSubview(stack)
        stack.addArrangedSubview(birthDate)
        stack.addArrangedSubview(datePicker)
        view.addSubview(segmentedControll)
    }
    
    private func setupLayout() {
        profileImage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.height.equalTo(200)
        }
        
        name.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.left.equalTo(view).offset(40)
            make.right.equalTo(view).inset(40)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
        
        segmentedControll.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(35)
            make.left.equalTo(view).offset(60)
            make.right.equalTo(view).inset(60)
        }
    }
    
    private func fillSettings() {
        name.text = names?.entity.name
        profileImage.image = UIImage(named: "male")
    }
}
