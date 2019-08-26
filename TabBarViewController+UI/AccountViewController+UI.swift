//
//  AccountViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/23/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

extension AccountViewController {
    /*
     Controll TableView and NavigationBar
    */
    func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Account"
    }
    
    
    
    
    
    /*
     Control Cell TextFields
    */
    func setupTextField(cell: ProfileCell, text: String?) {
//        let placeholderAttr = NSMutableAttributedString(string: text!, attributes:
//            [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
//        cell.inputTextField.attributedPlaceholder = placeholderAttr
//        cell.inputTextField.textAlignment = .center
        cell.inputTextField.text = text!
        cell.inputTextField.font = UIFont.systemFont(ofSize: 15)
    }
    
    @objc func handleTextField(sender: UITextField) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        switch sender.tag {
        case 1:
            fullname = cell.inputTextField.text!
        case 2:
            username = cell.inputTextField.text!
        case 4:
            status = cell.inputTextField.text!
        default:
            break
        }
    }
    
    
    
    
    
    /*
     Control Edit/Done Label in cell
    */
    @objc func handleEditProfile(sender: UILabel) {
        editInAction = true
        tableView.reloadData()
    }
    
    @objc func handleDoneEdit(sender: UILabel) {
        if self.image != nil {
            self.imageStorage(onSuccess: {
            }) { (errorMessage) in
                print(errorMessage)
            }
        }
        
        Api.User.updateFullname(text: fullname)
        Api.User.updateUsername(text: username)
        Api.User.status(text: status)
        
        doneEditTriggered = true
        editInAction = false
        
        tableView.reloadData()
    }
    
    
    
    
    
    /*
     Control Keyboard
    */
    func keyboardTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    /*
     Control ProfileImage
    */
    func setProfileImage(cell: ProfileCell, url: URL) {
        if self.image != nil {
            cell.profileImageView.image = self.image
        } else {
            cell.profileImageView.kf.setImage(with: url)
        }
        cell.profileImageView.contentMode = .scaleAspectFill
        cell.profileImageView.layer.cornerRadius = 100 / 2
        cell.profileImageView.clipsToBounds = true
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imageStorage(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.ProfileImage(image: self.image, onSuccess: {
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        
        if let imageSelected = info[.originalImage] as? UIImage {
            image = imageSelected
            cell.profileImageView.image = imageSelected
        }
        
        if let imageEdited = info[.editedImage] as? UIImage {
            image = imageEdited
            cell.profileImageView.image = imageEdited
        }
        dismiss(animated: true, completion: nil)
    }
}
