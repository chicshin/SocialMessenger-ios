//
//  SignUpViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

extension SignUpViewController {
    /*
     Control Blur Background
     */
    func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1
        view.addSubview(blurEffectView)
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(fullnameTextField)
        view.addSubview(fullnameTextCount)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(fullnameBottomLineView)
        view.addSubview(emailBottomLineView)
        view.addSubview(passwordBottomLineView)
        view.addSubview(createAccountButton)
        view.addSubview(ageCheckBox)
    }
    
    
    
    
    /*
     Control Textfield
    */
    func handleTextFields() {
        fullnameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let fullname = fullnameTextField.text, !fullname.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            createAccountButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
            createAccountButton.layer.borderWidth = 2
            createAccountButton.layer.borderColor = UIColor.lightGray.cgColor
            createAccountButton.backgroundColor = .clear
            createAccountButton.isUserInteractionEnabled = false
            return
        }

        if isChecked {
            createAccountButton.setTitleColor(.white, for: UIControl.State.normal)
            createAccountButton.layer.borderWidth = 0
            createAccountButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
            createAccountButton.isUserInteractionEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = self.fullnameTextField.text!.count + string.utf16.count - range.length
        fullnameTextCount.isHidden = false
        if length == 0 {
            fullnameTextCount.isHidden = true
        }
        if length <= 30 {
            self.fullnameTextCount.text = "\(length)/30"
            return true
        } else {
            print("text count out of range")
            return false
        }
    }
    
    func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.signUp(fullname: fullnameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, username: usernameReceived, onSuccess: {
            print("database created")
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
        
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 43).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: dismissButton.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 315).isActive = true
        
        fullnameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20).isActive = true
        fullnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -25).isActive = true
        fullnameTextField.widthAnchor.constraint(equalToConstant: 220).isActive = true
        fullnameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        fullnameTextCount.centerYAnchor.constraint(equalTo: fullnameTextField.centerYAnchor).isActive = true
        fullnameTextCount.leftAnchor.constraint(equalTo: fullnameTextField.rightAnchor, constant: 5).isActive = true
        fullnameTextCount.widthAnchor.constraint(equalToConstant: 50).isActive = true
        fullnameTextCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        fullnameBottomLineView.topAnchor.constraint(equalTo: fullnameTextField.bottomAnchor).isActive = true
        fullnameBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fullnameBottomLineView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        fullnameBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: fullnameTextField.bottomAnchor, constant: 20).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 270).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        emailBottomLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailBottomLineView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        emailBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 270).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        passwordBottomLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordBottomLineView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        passwordBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        createAccountButton.topAnchor.constraint(equalTo: passwordBottomLineView.bottomAnchor, constant: 30).isActive = true
        createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        createAccountButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        ageCheckBox.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 10).isActive = true
        ageCheckBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ageCheckBox.widthAnchor.constraint(equalToConstant: 150).isActive = true
        ageCheckBox.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
