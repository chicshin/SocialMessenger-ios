//
//  AccountViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/23/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import CropViewController

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var tableView: UITableView! = UITableView()

    var CurrentUser = [CurrentUserModel]()
    var contents = ["ProfileImageUrl", "Name", "Username", "Email", "Status"]
    var editInAction = false
    var doneEditTriggered = false
    
    var image : UIImage? = nil
    var status = ""
    var fullname = ""
    var username = ""
    
    let imageView = UIImageView()
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Block().observeFlaggedUser(completion: { (snapshot) in
            if snapshot {
                self.signOutFlaggedUserAlert()
            }
        })
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        
        view.addSubview(tableView)
        
        keyboardTapGestureRecognizer()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
                return 180
            }
            else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
                return 180
            } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
                return 170
            } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
                return 160
            } else {
                return 150
            }
        } else {
            if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
                return 50
            }
            else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
                return 50
            } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
                return 50
            } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
                return 45
            } else {
                return 45
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let content = contents[indexPath.row]
        cell.inputTextField.delegate = self
        
        cell.contentTitle.text = content
        
        cell.inputTextField.tag = indexPath.row
        
        
        didTapEditProfile(cell: cell)
        didTapDoneEdit(cell: cell)
        didTapEditProfileImage(cell: cell)
        
        setEditInAction(cell: cell)
        
        Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                switch indexPath.row {
                case 0:
                    let url = URL(string: dictionary["profileImageUrl"] as! String)
                    self.setProfileImage(cell: cell, url: url!)
                    
                    cell.contentTitle.isHidden = true
                    cell.bottomLine.isHidden = true
                    self.setEmailAndProfileCell(cell: cell)
                case 1:
                    cell.contentLabel.text = dictionary["fullname"] as? String
                    self.fullname = cell.contentLabel.text!
                    self.setCell(cell: cell)
                    self.setTextField(cell: cell)
                case 2:
                    cell.contentLabel.text = dictionary["username"] as? String
                    self.username = cell.contentLabel.text!
                    self.setCell(cell: cell)
                    self.setTextField(cell: cell)
                case 3:
                    cell.contentLabel.text = dictionary["email"] as? String
                    cell.contentLabel.textColor = .lightGray
                    
                    cell.contentTitle.isHidden = false
                    cell.contentLabel.isHidden = false
                    self.setCell(cell: cell)
                    self.setEmailAndProfileCell(cell: cell)
                case 4:
                    cell.contentLabel.text = dictionary["status"] as? String
                    self.status = cell.contentLabel.text!
                    self.setCell(cell: cell)
                    self.setTextField(cell: cell)
                default:
                    break
                }
            }
        })
        return cell
    }
    
    func setCell(cell: ProfileCell) {
        cell.editProfileLabel.isHidden = true
        cell.doneEditLabel.isHidden = true
        cell.seperateLine.isHidden = true
        cell.editProfileImage.isHidden = true
    }
    
    func setTextField(cell: ProfileCell) {
        self.setupTextField(cell: cell, text: cell.contentLabel.text)
        self.didTapTextField(cell: cell)
    }
    
    func setEmailAndProfileCell(cell: ProfileCell) {
        cell.textCountLabel.isHidden = true
        cell.inputTextField.isHidden = true
        cell.editTextFieldIndicator.isHidden = true
    }
    
    func setEditInAction(cell: ProfileCell) {
        if editInAction == true {
            cell.inputTextField.isHidden = false
            cell.editTextFieldIndicator.isHidden = false
            cell.contentLabel.isHidden = true
            cell.editProfileLabel.isHidden = true
            cell.doneEditLabel.isHidden = false
            cell.editProfileImage.isHidden = false
            
            cell.inputTextField.isUserInteractionEnabled = true
            
        } else {
            cell.inputTextField.isHidden = true
            cell.editTextFieldIndicator.isHidden = true
            cell.contentLabel.isHidden = false
            cell.editProfileLabel.isHidden = false
            cell.doneEditLabel.isHidden = true
            cell.editProfileImage.isHidden = true
            cell.textCountLabel.isHidden = true
        }
    }
    
    func didTapEditProfile(cell: ProfileCell) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEditProfile(sender:)))
        cell.editProfileLabel.addGestureRecognizer(tapGesture)
    }

    func didTapTextField(cell: ProfileCell) {
        cell.inputTextField.addTarget(self, action: #selector(handleTextField(sender:)), for: .allEditingEvents)
    }
    
    func didTapEditProfileImage(cell: ProfileCell) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        cell.editProfileImage.addGestureRecognizer(tapGesture)
    }
    
    func didTapDoneEdit(cell: ProfileCell) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoneEdit(sender:)))
        cell.doneEditLabel.addGestureRecognizer(tapGesture)
    }

}


class ProfileCell: UITableViewCell {
    var contentTitle: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var contentLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var profileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var bottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1)
        return line
    }()
    
    var seperateLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1)
        return line
    }()
    
    var inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .none
        textfield.backgroundColor = .clear
        return textfield
    }()
    
    var editProfileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.text = "Edit profile"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1)
        return label
    }()
    
    var editTextFieldIndicator: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = #imageLiteral(resourceName: "edit").withRenderingMode(.alwaysTemplate)
        image.tintColor = .lightGray
        return image
    }()
    
    var doneEditLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.text = "Done edit"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1)
        return label
    }()
    
    var editProfileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.image = #imageLiteral(resourceName: "add_photo").withRenderingMode(.alwaysTemplate)
        image.tintColor = #colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1)
        image.clipsToBounds = true
        return image
    }()
    
    var textCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(contentTitle)
        addSubview(contentLabel)
        addSubview(bottomLine)
        addSubview(profileImageView)
        addSubview(seperateLine)
        addSubview(editProfileLabel)
        addSubview(doneEditLabel)
        addSubview(editProfileImage)
        
        addSubview(inputTextField)
        addSubview(editTextFieldIndicator)
        addSubview(textCountLabel)
        
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            contentTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            contentTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
            contentTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentTitle.font = UIFont.systemFont(ofSize: 15)
            
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            contentLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            contentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentLabel.font = UIFont.systemFont(ofSize: 15)
            
            bottomLine.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
            bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            bottomLine.widthAnchor.constraint(equalToConstant: 250).isActive = true
            bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.layer.cornerRadius = 100 / 2
            
            editProfileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            editProfileLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            editProfileLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            editProfileLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            editProfileLabel.font = UIFont.systemFont(ofSize: 14)
            
            editProfileImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editProfileImage.centerYAnchor.constraint(equalTo: doneEditLabel.centerYAnchor).isActive = true
            editProfileImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
            editProfileImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            doneEditLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            doneEditLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            doneEditLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneEditLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            doneEditLabel.font = UIFont.systemFont(ofSize: 14)
            
            seperateLine.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
            seperateLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            seperateLine.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            inputTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
            inputTextField.widthAnchor.constraint(equalToConstant: 190).isActive = true
            inputTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            editTextFieldIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            editTextFieldIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editTextFieldIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
            editTextFieldIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            textCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            textCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
            textCountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textCountLabel.font = UIFont.systemFont(ofSize: 14)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            contentTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            contentTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
            contentTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentTitle.font = UIFont.systemFont(ofSize: 15)
            
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            contentLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            contentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentLabel.font = UIFont.systemFont(ofSize: 15)
            
            bottomLine.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
            bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            bottomLine.widthAnchor.constraint(equalToConstant: 250).isActive = true
            bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.layer.cornerRadius = 100 / 2
            
            editProfileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            editProfileLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            editProfileLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            editProfileLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            editProfileLabel.font = UIFont.systemFont(ofSize: 14)
            
            editProfileImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editProfileImage.centerYAnchor.constraint(equalTo: doneEditLabel.centerYAnchor).isActive = true
            editProfileImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
            editProfileImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            doneEditLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            doneEditLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            doneEditLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneEditLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            doneEditLabel.font = UIFont.systemFont(ofSize: 14)
            
            seperateLine.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
            seperateLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            seperateLine.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            inputTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
            inputTextField.widthAnchor.constraint(equalToConstant: 190).isActive = true
            inputTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            editTextFieldIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            editTextFieldIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editTextFieldIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
            editTextFieldIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            textCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            textCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
            textCountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textCountLabel.font = UIFont.systemFont(ofSize: 14)
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            contentTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            contentTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
            contentTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentTitle.font = UIFont.systemFont(ofSize: 14)
            
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            contentLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            contentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentLabel.font = UIFont.systemFont(ofSize: 14)
            
            bottomLine.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
            bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            bottomLine.widthAnchor.constraint(equalToConstant: 250).isActive = true
            bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 95).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 95).isActive = true
            profileImageView.layer.cornerRadius = 95 / 2
            
            editProfileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            editProfileLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            editProfileLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            editProfileLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            editProfileLabel.font = UIFont.systemFont(ofSize: 13)
            
            editProfileImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editProfileImage.centerYAnchor.constraint(equalTo: doneEditLabel.centerYAnchor).isActive = true
            editProfileImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
            editProfileImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            doneEditLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            doneEditLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            doneEditLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneEditLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            doneEditLabel.font = UIFont.systemFont(ofSize: 13)
            
            seperateLine.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
            seperateLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            seperateLine.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            inputTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
            inputTextField.widthAnchor.constraint(equalToConstant: 190).isActive = true
            inputTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            editTextFieldIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            editTextFieldIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editTextFieldIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
            editTextFieldIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            textCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            textCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
            textCountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textCountLabel.font = UIFont.systemFont(ofSize: 13)
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            contentTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            contentTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
            contentTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentTitle.font = UIFont.systemFont(ofSize: 14)
            
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            contentLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            contentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentLabel.font = UIFont.systemFont(ofSize: 14)
            
            bottomLine.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
            bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            bottomLine.widthAnchor.constraint(equalToConstant: 250).isActive = true
            bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 95).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 95).isActive = true
            profileImageView.layer.cornerRadius = 95 / 2
            
            editProfileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            editProfileLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            editProfileLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            editProfileLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            editProfileLabel.font = UIFont.systemFont(ofSize: 13)
            
            editProfileImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editProfileImage.centerYAnchor.constraint(equalTo: doneEditLabel.centerYAnchor).isActive = true
            editProfileImage.heightAnchor.constraint(equalToConstant: 17).isActive = true
            editProfileImage.widthAnchor.constraint(equalToConstant: 17).isActive = true
            
            doneEditLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            doneEditLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            doneEditLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneEditLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            doneEditLabel.font = UIFont.systemFont(ofSize: 13)
            
            seperateLine.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
            seperateLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            seperateLine.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            inputTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
            inputTextField.widthAnchor.constraint(equalToConstant: 190).isActive = true
            inputTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            editTextFieldIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            editTextFieldIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editTextFieldIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
            editTextFieldIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            textCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            textCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
            textCountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textCountLabel.font = UIFont.systemFont(ofSize: 13)
        } else {
            contentTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            contentTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
            contentTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentTitle.font = UIFont.systemFont(ofSize: 13)
            
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            contentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            contentLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            contentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            contentLabel.font = UIFont.systemFont(ofSize: 13)
            
            bottomLine.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
            bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            bottomLine.widthAnchor.constraint(equalToConstant: 200).isActive = true
            bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 85).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 85).isActive = true
            profileImageView.layer.cornerRadius = 85 / 2
            
            editProfileLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            editProfileLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            editProfileLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            editProfileLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            editProfileLabel.font = UIFont.systemFont(ofSize: 12)
            
            editProfileImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editProfileImage.centerYAnchor.constraint(equalTo: doneEditLabel.centerYAnchor).isActive = true
            editProfileImage.heightAnchor.constraint(equalToConstant: 17).isActive = true
            editProfileImage.widthAnchor.constraint(equalToConstant: 17).isActive = true
            
            doneEditLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 7).isActive = true
            doneEditLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            doneEditLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneEditLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            doneEditLabel.font = UIFont.systemFont(ofSize: 12)
            
            seperateLine.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
            seperateLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            seperateLine.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            inputTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
            inputTextField.widthAnchor.constraint(equalToConstant: 140).isActive = true
            inputTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            editTextFieldIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            editTextFieldIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            editTextFieldIndicator.widthAnchor.constraint(equalToConstant: 17).isActive = true
            editTextFieldIndicator.heightAnchor.constraint(equalToConstant: 17).isActive = true
            
            textCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            textCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
            textCountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textCountLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
