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
    
    var presenter: ProfilePresenterProtocol?
    
    var gender = ["Male", "Female"]
    var blockedProfileEditing = false
    let dateFormatter = DateFormatter()
    
    // MARK: - Outlets
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addUserImage))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var name: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        textField.layer.cornerRadius = 10
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        picker.tintColor = .systemGreen
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 10
        picker.isUserInteractionEnabled = false
        return picker
    }()
    
    private lazy var segmentedControll: UISegmentedControl = {
        let segment = UISegmentedControl(items: gender)
        let font = UIFont.systemFont(ofSize: 16)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segment.addTarget(self, action: #selector(selectedGender), for: .valueChanged)
        segment.selectedSegmentTintColor = .systemYellow
        segment.isUserInteractionEnabled = false
        return segment
    }()
    
    private let birthDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        dateFormatter.dateFormat = "dd.MM.yyyy"
        setupNavigationController()
        setupHierarchy()
        setupLayout()
        presenter?.setData()
    }
    
    // MARK: - Setup
    
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
        
        segmentedControll.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(35)
            make.left.equalTo(view).offset(40)
            make.right.equalTo(view).inset(40)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(segmentedControll.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
    }
    
    func setupNavigationController() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveButton))
        navigationController?.navigationBar.tintColor = UIColor.systemYellow
    }
    
    // MARK: - Actions
    
    @objc func selectedGender(target: UISegmentedControl) -> String? {
        var genderValue = String()
        let segmentIndex = target.selectedSegmentIndex
        genderValue = gender[segmentIndex]
        
        return genderValue
    }
    
    @objc func saveButton() {
        blockedProfileEditing.toggle()
        if blockedProfileEditing {
            navigationItem.rightBarButtonItem?.title = "Save"
            navigationItem.rightBarButtonItem?.tintColor = .systemGreen
            name.isUserInteractionEnabled = true
            name.backgroundColor = .lightGray
            
            profileImage.isUserInteractionEnabled = true
            profileImage.layer.borderWidth = 3
            profileImage.layer.borderColor = UIColor.systemGreen.cgColor
            
            datePicker.isUserInteractionEnabled = true
            datePicker.backgroundColor = .systemGreen
            
            segmentedControll.isUserInteractionEnabled = true
            segmentedControll.backgroundColor = .systemGreen
        } else {
            navigationItem.rightBarButtonItem?.title = "Edit"
            navigationItem.rightBarButtonItem?.tintColor = .systemYellow
            name.isUserInteractionEnabled = false
            name.backgroundColor = .clear
            
            profileImage.tintColor = .black
            profileImage.layer.borderWidth = .zero
            profileImage.isUserInteractionEnabled = false
            
            datePicker.isUserInteractionEnabled = false
            datePicker.backgroundColor = .clear
            
            segmentedControll.isUserInteractionEnabled = false
            segmentedControll.backgroundColor = .clear
        }
        
        if !blockedProfileEditing {
            let name = name.text
            let birthDate = datePicker.date
            let gender = segmentedControll.selectedSegmentIndex != UISegmentedControl.noSegment ? selectedGender(target: segmentedControll) : "Other"
            let image = profileImage.image != UIImage(systemName: "person.crop.circle.fill") ? profileImage.image?.pngData() : nil
            presenter?.savePerson(name: name, birthDate: birthDate, gender: gender, image: image)
        }
    }
    
    @objc func addUserImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileViewProtocol {
    
    func setupProfileView(person: Person?) {
        if let personName = person?.name {
            name.text = personName
        }
        
        if let date = person?.birthDate {
            datePicker.date = date
        }
        
        if let image = person?.image {
            if person?.image != nil {
                profileImage.image = UIImage(data: image)
            } else {
                profileImage.image = UIImage(systemName: "person.crop.circle.fill")
            }
        }
        
        if let gender = person?.gender {
            if gender == "Male" {
                segmentedControll.selectedSegmentIndex = 0
            } else if gender == "Female" {
                segmentedControll.selectedSegmentIndex = 1
            }
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profileImage.image  = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
