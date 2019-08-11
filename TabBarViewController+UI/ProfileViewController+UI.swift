//
//  ProfileViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import AlamofireImage

extension ProfileViewController {
    func setupBackgroundImage() {
        backgroundImage.clipsToBounds = true
    }
    
    func setupProfileImage() {
        let uid = Auth.auth().currentUser?.uid
        
        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
            if let dict = dataSnapShot.value as? [String:Any] {
                let name = dict["fullname"] as! String
                self.nameLabel.text = name
                let urlString = dict["profileImageUrl"] as! String
                let url = URL(string: urlString)
                self.profileImage.kf.setImage(with: url)
            }
        })
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }
    
    func setupFullname() {
        let uid = Auth.auth().currentUser?.uid

        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
            if let dict = dataSnapShot.value as? [String:Any] {
                let name = dict["fullname"] as! String
                self.nameLabel.text = name
                self.nameLabel.font = UIFont.systemFont(ofSize: 20)
                self.nameLabel.textAlignment = .center
            }
        })
    }

    
    func setupEditButton() {
        editButton.tintColor = .darkGray
//        editButton.setImage(#imageLiteral(resourceName: "edit"), for: UIControl.State.normal)
//        editButton.imageEdgeInsets = UIEdgeInsets(top: -40, left: 25, bottom: 0, right: 0)
        editButton.titleLabel?.text = "Edit Profile"
//        editButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editImage.image = #imageLiteral(resourceName: "edit")
    }
    
    func setupDoneButton() {
        let title = "Done"
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        doneButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    @objc func showDoneButton() {
        doneButton.isHidden = false
    }
    
    func setupCloseButton() {
        closeButton.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        closeButton.tintColor = .black
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
            self.doneButton.isHidden = true
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[.originalImage] as? UIImage {
            image = imageSelected
            profileImage.image = imageSelected
        }
        if let imageSelected = info[.editedImage] as? UIImage {
            image = imageSelected
            profileImage.image = imageSelected
        }
        dismiss(animated: true, completion: nil)
        showDoneButton()
    }
}
