//
//  ResetPasswordViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/4/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import ProgressHUD

extension ResetPasswordViewController {
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
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailBottomLineView)
        view.addSubview(resetButton)
        view.addSubview(dismissButton)
    }
    
    
    
    
    /*
        Control Textfield
    */
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty else {
            resetButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
            resetButton.layer.borderWidth = 2
            resetButton.layer.borderColor = UIColor.lightGray.cgColor
            resetButton.backgroundColor = .clear
            resetButton.isUserInteractionEnabled = false
            return
        }
        resetButton.setTitleColor(.white, for: UIControl.State.normal)
        resetButton.layer.borderWidth = 0
        resetButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        resetButton.isUserInteractionEnabled = true
    }
    
    func validateFields() {
        guard let email = self.emailTextField.text, email != "" else{
            ProgressHUD.showError(ERROR_EMPTY_EMAIL_RESET)
            return
        }
    }
    
    func setupConstraints() {
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 270).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        emailBottomLineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailBottomLineView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        emailBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        resetButton.topAnchor.constraint(equalTo: emailBottomLineView.bottomAnchor, constant: 30).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
        resetButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
