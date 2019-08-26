//
//  ViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

extension SignInViewController {
    func setupTitle() {
        let title = "CLUSTER"
//        let subTitle = "  Talk"
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.init(name: "TrebuchetMS", size: 45)!
            ])
        
//        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
//            [NSAttributedString.Key.font : UIFont.init(name: "Copperplate", size: 10)!
//            ])
//
//        attributedText.append(attributedSubText)
        titleLabel.attributedText = attributedText
    }
    
    func setupEmailTextField() {
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5).cgColor
        emailContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        emailContainerView.layer.cornerRadius = 3
        emailContainerView.clipsToBounds = true
        
        let placeholderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        emailTextField.borderStyle = .none
        emailTextField.attributedPlaceholder = placeholderAttr
        emailTextField.textColor = .black
    }
    
    func setupPasswordTextField() {
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5).cgColor
        passwordContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        passwordContainerView.layer.cornerRadius = 3
        passwordContainerView.clipsToBounds = true
        
        let placeholderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        passwordTextField.borderStyle = .none
        passwordTextField.attributedPlaceholder = placeholderAttr
        passwordTextField.textColor = .black
    }
    
    func setupSignIn() {
        signInButton.setTitle("Sign In", for: UIControl.State.normal)
//        signInButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.7)
        signInButton.backgroundColor = .lightGray
        signInButton.layer.cornerRadius = 5
        signInButton.setTitleColor(.white, for: UIControl.State.normal)
        signInButton.isUserInteractionEnabled = false
    }
    
    func setupForgotPassword() {
        forgotPasswordButton.setTitle("Forgot password?", for: UIControl.State.normal)
        forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        forgotPasswordButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8), for: UIControl.State.normal)
    }
    
    func setupSignUp() {
        let title = "Don't have an account? "
        let subtitle = "Sign Up"
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        let attributedSubText = NSMutableAttributedString(string: subtitle, attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
        
        attributedText.append(attributedSubText)
        signUpButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    func handleTextFields(){
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
            signInButton.backgroundColor = .lightGray
            signInButton.isUserInteractionEnabled = false
            return
        }
        signInButton.setTitleColor(.white, for: UIControl.State.normal)
        signInButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1)
        signInButton.isUserInteractionEnabled = true
    }
    
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            onSuccess()
        }) {(errorMessage) in
            onError(errorMessage)
        }
    }
}


