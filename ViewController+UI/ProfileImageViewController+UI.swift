//
//  ProfileImageViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

extension ProfileImageViewController {
    /*
     Control Blur Background
     */
    func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurBackground = UIVisualEffectView(effect: blurEffect)
        blurBackground!.frame = view.bounds
        blurBackground!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurBackground!.alpha = 1
        view.addSubview(blurBackground!)
        view.addSubview(welcomeLabel)
        view.addSubview(usernameLabel)
        view.addSubview(doneButton)
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(setImageButton)
        view.addSubview(skipButton)
    }
    
    func loadWelcomeMessage() {
        usernameLabel.text = usernameReceived
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurBackground?.alpha = 0
            self.doneButton.alpha = 0
            self.profileImageView.alpha = 0
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.setImageButton.alpha = 0
            self.skipButton.alpha = 0
            self.welcomeLabel.alpha = 0.8
            self.usernameLabel.alpha = 0.8
            self.welcomeLabel.isHidden = false
            self.usernameLabel.isHidden = false
        }, completion: nil)
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
    
    func setupConstraints() {
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 43).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 70).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 315).isActive = true
        
        setImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30).isActive = true
        setImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        setImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //        welcomeUsernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
    }
}

extension ProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[.originalImage] as? UIImage {
            image = imageSelected
            profileImageView.image = imageSelected
        }
        
        if let imageEdited = info[.editedImage] as? UIImage {
            image = imageEdited
            profileImageView.image = imageEdited
        }
        doneButton.isHidden = false
        dismiss(animated: true, completion: nil)
    }
}
