//
//  ProfileImageViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

extension ProfileImageViewController {
    func setupImageView() {
        imageContainerView.layer.borderWidth = 1
        imageContainerView.layer.cornerRadius = 10
        imageContainerView.clipsToBounds = true
        
        imageView.image = #imageLiteral(resourceName: "add_photo")
        
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        //let the signup view present the image picker controller
        self.present(picker, animated: true, completion: nil)
    }
    
    func setupTitle() {
        let title = "Add Profile Picture"
        let subTitle = "\nAdd a profile photo so your friends know it's you. You can always change it later."
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30),
             NSAttributedString.Key.foregroundColor : UIColor.black])
        
        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!,
             NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.9)])
        
        attributedText.append(attributedSubText)
        titleLabel.attributedText = attributedText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 4
    }
    func setupSubmitButton() {
        submitButton.setTitle("Add a photo", for: UIControl.State.normal)
        submitButton.setTitleColor(.white, for: UIControl.State.normal)
        submitButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.7)
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        submitButton.isUserInteractionEnabled = false
    }
    
    func setupSkip() {
        let title = "Skip"
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        skipButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    func setupDone() {
        let title = "Done"
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        doneButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    func imageStorage(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.ProfileImage(image: self.image, onSuccess: {
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
}

extension ProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[.originalImage] as? UIImage {
            image = imageSelected
            imageView.image = imageSelected
        }
        
        if let imageEdited = info[.editedImage] as? UIImage {
            image = imageEdited
            imageView.image = imageEdited
        }
        
        dismiss(animated: true, completion: nil)
    }
}
