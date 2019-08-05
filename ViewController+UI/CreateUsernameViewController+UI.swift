//
//  SignUpViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

extension CreateUsernameViewController {
    func setupTitle() {
        let title = "Create Username"
        let subTitle = "\n\nPick a username for your account. You can always change it later."
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30),
             NSAttributedString.Key.foregroundColor : UIColor.black])
        
        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
             NSAttributedString.Key.foregroundColor : UIColor.black.withAlphaComponent(0.9)])
        
        attributedText.append(attributedSubText)
        titleLabel.attributedText = attributedText
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 4
    }
    func setupUsernameTextField() {
        usernameContainerView.layer.borderWidth = 1
        usernameContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5).cgColor
        usernameContainerView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
        usernameContainerView.layer.cornerRadius = 3
        usernameContainerView.clipsToBounds = true
        
        let placeholderAttr = NSMutableAttributedString(string: "Enter username", attributes:
            [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        usernameTextField.borderStyle = .none
        usernameTextField.attributedPlaceholder = placeholderAttr
        usernameTextField.textColor = .black
        
    }
    
    func setupNext() {
        nextButton.setTitle("Next", for: UIControl.State.normal)
        nextButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.7)
        nextButton.layer.cornerRadius = 5
        nextButton.clipsToBounds = true
        nextButton.setTitleColor(.white, for: UIControl.State.normal)
        nextButton.isUserInteractionEnabled = false
    }
    
    func setupSignIn() {
        let title = "Already have an account? "
        let subTitle = "Sign In"
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13),
             NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
        
        attributedText.append(attributedSubText)
        signInButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
    }
    
    func handleTextFields(){
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(){
        guard let username = usernameTextField.text, !username.isEmpty else{
            nextButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1).withAlphaComponent(0.7)
            nextButton.isUserInteractionEnabled = false
            dismissError()
            return
        }
        nextButton.setTitleColor(.white, for: UIControl.State.normal)
        nextButton.backgroundColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1)
        nextButton.isUserInteractionEnabled = true
        dismissError()
    }
    
    func setupInitialError() {
        usernameErrorMessageLabel.isHidden = true
        nextButtonTopLayout.constant = 5
    }
    
    func setupErrorLabel() {
        let message = "Username " + usernameSelected + " is already taken."
        
        let attributedText = NSMutableAttributedString(string: message, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor : UIColor.red])
        
        usernameErrorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameErrorMessageLabel.attributedText = attributedText
        usernameErrorMessageLabel.isHidden = false
        nextButtonTopLayout.constant = 20
    }
    
    func createUsername(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.createUsername(withUsername: usernameTextField.text!, onSuccess: {
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
    
    func handleError() {
        usernameContainerView.layer.borderColor = UIColor(red: 250, green: 0, blue: 0, alpha: 1).cgColor
    }
    
    func dismissError() {
        usernameErrorMessageLabel.isHidden = true
        nextButtonTopLayout.constant = 5
        usernameContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.5).cgColor
    }
}
