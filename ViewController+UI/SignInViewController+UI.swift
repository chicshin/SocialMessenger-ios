//
//  ViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

extension SignInViewController {
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
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(emailBottomLineView)
        view.addSubview(passwordBottomLineView)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(passwordResetButton)
    }
    
    
    
    
    
    /*
        Control Textfield
    */
    func handleTextFields(){
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else{
            signInButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
            signInButton.layer.borderWidth = 2
            signInButton.layer.borderColor = UIColor.lightGray.cgColor
            signInButton.backgroundColor = .clear
            signInButton.isUserInteractionEnabled = false
            return
        }
        signInButton.setTitleColor(.white, for: UIControl.State.normal)
        signInButton.layer.borderWidth = 0
        signInButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        signInButton.isUserInteractionEnabled = true
    }
    
    
    
    
    
    /*
        Control Sign In
    */
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            onSuccess()
        }) {(errorMessage) in
            onError(errorMessage)
        }
    }
    
    
    
    
    
    /*
     Control Contraints
     */
    func setupConstraints() {
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45).isActive = true
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
            
            signInButton.topAnchor.constraint(equalTo: passwordBottomLineView.bottomAnchor, constant: 30).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            passwordResetButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
            passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordResetButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            passwordResetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signUpButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) + -40).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
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
            
            signInButton.topAnchor.constraint(equalTo: passwordBottomLineView.bottomAnchor, constant: 30).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            passwordResetButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
            passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordResetButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            passwordResetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signUpButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) + -40).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emailTextField.widthAnchor.constraint(equalToConstant: 230).isActive = true
            emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            emailBottomLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
            emailBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emailBottomLineView.widthAnchor.constraint(equalToConstant: 240).isActive = true
            emailBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordTextField.widthAnchor.constraint(equalToConstant: 230).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            passwordBottomLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
            passwordBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordBottomLineView.widthAnchor.constraint(equalToConstant: 230).isActive = true
            passwordBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            signInButton.topAnchor.constraint(equalTo: passwordBottomLineView.bottomAnchor, constant: 30).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            passwordResetButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
            passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordResetButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            passwordResetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signUpButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) + -40).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emailTextField.widthAnchor.constraint(equalToConstant: 230).isActive = true
            emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            emailBottomLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
            emailBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emailBottomLineView.widthAnchor.constraint(equalToConstant: 240).isActive = true
            emailBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordTextField.widthAnchor.constraint(equalToConstant: 230).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            passwordBottomLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
            passwordBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordBottomLineView.widthAnchor.constraint(equalToConstant: 230).isActive = true
            passwordBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            signInButton.topAnchor.constraint(equalTo: passwordBottomLineView.bottomAnchor, constant: 30).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            passwordResetButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
            passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordResetButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            passwordResetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signUpButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) + -40).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emailTextField.widthAnchor.constraint(equalToConstant: 230).isActive = true
            emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            emailBottomLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
            emailBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emailBottomLineView.widthAnchor.constraint(equalToConstant: 240).isActive = true
            emailBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordTextField.widthAnchor.constraint(equalToConstant: 230).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            passwordBottomLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
            passwordBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordBottomLineView.widthAnchor.constraint(equalToConstant: 230).isActive = true
            passwordBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            signInButton.topAnchor.constraint(equalTo: passwordBottomLineView.bottomAnchor, constant: 30).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            passwordResetButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
            passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordResetButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            passwordResetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signUpButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        
//        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
//        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        titleLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
//
//        emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45).isActive = true
//        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        emailTextField.widthAnchor.constraint(equalToConstant: 270).isActive = true
//        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
//
//        emailBottomLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
//        emailBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        emailBottomLineView.widthAnchor.constraint(equalToConstant: 280).isActive = true
//        emailBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true
//        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        passwordTextField.widthAnchor.constraint(equalToConstant: 270).isActive = true
//        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
//
//        passwordBottomLineView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
//        passwordBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        passwordBottomLineView.widthAnchor.constraint(equalToConstant: 280).isActive = true
//        passwordBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//        signInButton.topAnchor.constraint(equalTo: passwordBottomLineView.bottomAnchor, constant: 30).isActive = true
//        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        signInButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
//        signInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        passwordResetButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
//        passwordResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        passwordResetButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        passwordResetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
//        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        signUpButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
