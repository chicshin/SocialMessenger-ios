//
//  SignUpViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

extension SignUpViewController {
    func setupBackButton() {
        backButton.setImage(UIImage.init(named: "back_icon"), for: UIControl.State.normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalToConstant: 30)
        backButton.widthAnchor.constraint(equalToConstant: 30)
        backButton.clipsToBounds = true
        backButton.tintColor = .black
    }
    func setupTitle() {
        let title = "Email and password"
        let subTitle = "\n\nLast step to create an account. Enter your name so friends may know it's you."
        
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
    
    func setupFullnameTextField() {
        fullnameContainerView.layer.borderWidth = 1
        fullnameContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5).cgColor
        fullnameContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        fullnameContainerView.layer.cornerRadius = 3
        fullnameContainerView.clipsToBounds = true
        
        let placeholderAttr = NSMutableAttributedString(string: "Fullname", attributes:
            [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        fullnameTextField.borderStyle = .none
        fullnameTextField.textColor = .black
        fullnameTextField.attributedPlaceholder = placeholderAttr
    }
    
    func setupEmailTextField() {
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5).cgColor
        emailContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        emailContainerView.layer.cornerRadius = 3
        emailContainerView.clipsToBounds = true
        
        let placeholderAttr = NSMutableAttributedString(string: "Email Address", attributes:
            [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        emailTextField.borderStyle = .none
        emailTextField.textColor = .black
        emailTextField.attributedPlaceholder = placeholderAttr
    }
    func setupPasswordTextField() {
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5).cgColor
        passwordContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        passwordContainerView.layer.cornerRadius = 3
        passwordContainerView.clipsToBounds = true
        
        let placeholderAttr = NSMutableAttributedString(string: "Password", attributes:
            [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        passwordTextField.borderStyle = .none
        passwordTextField.textColor = .black
        passwordTextField.attributedPlaceholder = placeholderAttr
    }
    func setupSubmitButton() {
        createAccountButton.setTitle("Create New Account", for: UIControl.State.normal)
        createAccountButton.setTitleColor(.white, for: UIControl.State.normal)
        createAccountButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.7)
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.clipsToBounds = true
        createAccountButton.isUserInteractionEnabled = false
    }
    
    func handleTextFields() {
        fullnameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange() {
        guard let fullname = fullnameTextField.text, !fullname.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            createAccountButton.isUserInteractionEnabled = false
            createAccountButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.7)
            return
        }
        createAccountButton.setTitleColor(.white, for: UIControl.State.normal)
        createAccountButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1)
        createAccountButton.isUserInteractionEnabled = true
    }
    
    func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.signUp(fullname: fullnameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, username: usernameLabel.text!, onSuccess: {
            print("database created")
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
    
    func hideUsername() {
        usernameLabel.textColor = .clear
    }
}
