//
//  ResetPasswordViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/4/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

extension ResetPasswordViewController {
    func setupClose() {
        closeButton.setImage(UIImage.init(named: "close_icon"), for: UIControl.State.normal)
        closeButton.heightAnchor.constraint(equalToConstant: 30)
        closeButton.widthAnchor.constraint(equalToConstant: 30)
        closeButton.tintColor = .black
        closeButton.clipsToBounds = true
    }
    func setupTitle() {
        let title = "Reset Password"
        let subTitle = "\n\nEnter your email address you're are using for your account below. We will send a password rest link."
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30),
             NSAttributedString.Key.foregroundColor : UIColor.black])
        
        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!,
            NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.9)])
        
        attributedText.append(attributedSubText)
        titleLabel.attributedText = attributedText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 5
    }
    func setupEmailTextField() {
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5).cgColor
        emailContainerView.layer.cornerRadius = 3
        emailContainerView.clipsToBounds = true
        emailContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        
        let placeholderAttr = NSMutableAttributedString(string: "Email Address", attributes:
            [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        emailTextField.attributedPlaceholder = placeholderAttr
        emailTextField.borderStyle = .none
        emailTextField.textColor = .black
    }
    func setupReset() {
        resetButton.setTitle("Request Reset Link", for: UIControl.State.normal)
        resetButton.setTitleColor(.white, for: UIControl.State.normal)
        resetButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.7)
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
        resetButton.isUserInteractionEnabled = false
    }
    
    func handleTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty else {
            resetButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.7)
            resetButton.isUserInteractionEnabled = false
            return
        }
        resetButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1)
        resetButton.isUserInteractionEnabled = true
    }
    
    func validateFields() {
        guard let email = self.emailTextField.text, email != "" else{
            ProgressHUD.showError(ERROR_EMPTY_EMAIL_RESET)
            return
        }
    }
}
