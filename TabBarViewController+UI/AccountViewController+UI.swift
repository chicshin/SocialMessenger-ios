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
        cell.inputTextField.text = text!
        cell.inputTextField.font = UIFont.systemFont(ofSize: 15)
    }
    
    @objc func handleTextField(sender: UITextField) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        
        let fullnameIndexPath = IndexPath(row: 1, section: 0)
        let usernameIndexPath = IndexPath(row: 2, section: 0)
        let statusIndexPath = IndexPath(row: 4, section: 0)
        let fullnameCell = tableView.cellForRow(at: fullnameIndexPath) as! ProfileCell
        let usernameCell = tableView.cellForRow(at: usernameIndexPath) as! ProfileCell
        let statusCell = tableView.cellForRow(at: statusIndexPath) as! ProfileCell
        
        switch sender.tag {
        case 1:
            fullname = cell.inputTextField.text!
            let initCount = fullname.count
            cell.textCountLabel.text = "\(initCount)/30"
            cell.textCountLabel.isHidden = false
            usernameCell.textCountLabel.isHidden = true
            statusCell.textCountLabel.isHidden = true
        case 2:
            username = cell.inputTextField.text!
            let initCount = username.count
            cell.textCountLabel.text = "\(initCount)/25"
            cell.textCountLabel.isHidden = false
            fullnameCell.textCountLabel.isHidden = true
            statusCell.textCountLabel.isHidden = true
        case 4:
            status = cell.inputTextField.text!
            let initCount = status.count
            cell.textCountLabel.text = "\(initCount)/30"
            cell.textCountLabel.isHidden = false
            fullnameCell.textCountLabel.isHidden = true
            usernameCell.textCountLabel.isHidden = true
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        let length = cell.inputTextField.text!.count + string.utf16.count - range.length
        
        switch tag {
        case 1:
            if length <= 30 {
                return true
            } else {
                return false
            }
        case 2:
            if length <= 25 {
                return true
            } else {
                return false
            }
        case 4:
            if length <= 30 {
                return true
            } else {
                return false
            }
        default:
            break
        }
        return true
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
