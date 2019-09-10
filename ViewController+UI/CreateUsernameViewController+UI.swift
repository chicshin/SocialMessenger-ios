//
//  SignUpViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

extension CreateUsernameViewController {
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
        view.addSubview(usernameTextField)
        view.addSubview(usernameTextCount)
        view.addSubview(usernameBottomLineView)
        view.addSubview(usernameExistsErrorMessage)
        view.addSubview(restrictSpecialCharactersMessage)
        view.addSubview(nextButton)
        view.addSubview(signInButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
    /*
        Control Restrict Special Characters Error Message
    */
    func setupErrorLabel() {
        usernameExistsErrorMessage.isHidden = false
        nextButtonTopAnchorWithErrorShows?.isActive = true
        nextButtonTopAnchor?.isActive = false
    }
    
    func dismissError() {
        usernameExistsErrorMessage.isHidden = true
        restrictSpecialCharactersMessage.isHidden = true
        nextButtonTopAnchorWithErrorShows?.isActive = false
        nextButtonTopAnchor?.isActive = true
    }
    
    
    
    
    /*
        Control Textfield
    */
    func handleTextFields() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(){
        guard let username = usernameTextField.text, !username.isEmpty else{
            nextButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
            nextButton.layer.borderWidth = 2
            nextButton.layer.borderColor = UIColor.lightGray.cgColor
            nextButton.backgroundColor = .clear
            nextButton.isUserInteractionEnabled = false
            dismissError()
            return
        }
        nextButton.setTitleColor(.white, for: UIControl.State.normal)
        nextButton.layer.borderWidth = 0
        nextButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        nextButton.isUserInteractionEnabled = true
        dismissError()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        let length = self.usernameTextField.text!.count + string.utf16.count - range.length
        usernameTextCount.isHidden = false
        
        if string == filtered && length <= 25 {
            restrictSpecialCharactersMessage.isHidden = true
            nextButtonTopAnchorWithErrorShows?.isActive = false
            nextButtonTopAnchor?.isActive = true
            nextButton.isUserInteractionEnabled = true
            self.usernameTextCount.text = "\(length)/25"
            return true
        } else {
            usernameExistsErrorMessage.isHidden = true
            restrictSpecialCharactersMessage.isHidden = false
            nextButtonTopAnchorWithErrorShows?.isActive = true
            nextButtonTopAnchor?.isActive = false
            if self.usernameTextField.text!.count == 20 {
                restrictSpecialCharactersMessage.isHidden = true
                nextButtonTopAnchorWithErrorShows?.isActive = false
                nextButtonTopAnchor?.isActive = true
            }
            nextButton.isUserInteractionEnabled = false
            return false
        }
    }
    
    
    
    
    
    /*
        Control Create Username
    */
    func createUsername(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.createUsername(withUsername: usernameTextField.text!, onSuccess: {
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
    
    
    
    
    
    /*
        Control Contraints
    */
    func setupConstraints() {
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30).isActive = true
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameTextField.widthAnchor.constraint(equalToConstant: 240).isActive = true
            usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameTextCount.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
            usernameTextCount.leftAnchor.constraint(equalTo: usernameTextField.rightAnchor, constant: -30).isActive = true
            usernameTextCount.widthAnchor.constraint(equalToConstant: 40).isActive = true
            usernameTextCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameBottomLineView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
            usernameBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameBottomLineView.widthAnchor.constraint(equalToConstant: 250).isActive = true
            usernameBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            usernameExistsErrorMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            usernameExistsErrorMessage.leftAnchor.constraint(equalTo: usernameBottomLineView.leftAnchor).isActive = true
            usernameExistsErrorMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            usernameExistsErrorMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            restrictSpecialCharactersMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            restrictSpecialCharactersMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            restrictSpecialCharactersMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            restrictSpecialCharactersMessage.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 25)
            nextButtonTopAnchor?.isActive = true
            nextButtonTopAnchorWithErrorShows = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 50)
            nextButtonTopAnchorWithErrorShows?.isActive = false
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 45).isActive = true
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameTextCount.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
            usernameTextCount.leftAnchor.constraint(equalTo: usernameTextField.rightAnchor, constant: -30).isActive = true
            usernameTextCount.widthAnchor.constraint(equalToConstant: 40).isActive = true
            usernameTextCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameBottomLineView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
            usernameBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameBottomLineView.widthAnchor.constraint(equalToConstant: 210).isActive = true
            usernameBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            usernameExistsErrorMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            usernameExistsErrorMessage.leftAnchor.constraint(equalTo: usernameBottomLineView.leftAnchor).isActive = true
            usernameExistsErrorMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            usernameExistsErrorMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            restrictSpecialCharactersMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            restrictSpecialCharactersMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            restrictSpecialCharactersMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            restrictSpecialCharactersMessage.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 25)
            nextButtonTopAnchor?.isActive = true
            nextButtonTopAnchorWithErrorShows = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 50)
            nextButtonTopAnchorWithErrorShows?.isActive = false
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 45).isActive = true
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameTextCount.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
            usernameTextCount.leftAnchor.constraint(equalTo: usernameTextField.rightAnchor, constant: -30).isActive = true
            usernameTextCount.widthAnchor.constraint(equalToConstant: 40).isActive = true
            usernameTextCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameBottomLineView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
            usernameBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameBottomLineView.widthAnchor.constraint(equalToConstant: 210).isActive = true
            usernameBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            usernameExistsErrorMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            usernameExistsErrorMessage.leftAnchor.constraint(equalTo: usernameBottomLineView.leftAnchor).isActive = true
            usernameExistsErrorMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            usernameExistsErrorMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            restrictSpecialCharactersMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            restrictSpecialCharactersMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            restrictSpecialCharactersMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            restrictSpecialCharactersMessage.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 25)
            nextButtonTopAnchor?.isActive = true
            nextButtonTopAnchorWithErrorShows = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 50)
            nextButtonTopAnchorWithErrorShows?.isActive = false
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 45).isActive = true
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameTextCount.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
            usernameTextCount.leftAnchor.constraint(equalTo: usernameTextField.rightAnchor, constant: -30).isActive = true
            usernameTextCount.widthAnchor.constraint(equalToConstant: 40).isActive = true
            usernameTextCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameBottomLineView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
            usernameBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameBottomLineView.widthAnchor.constraint(equalToConstant: 210).isActive = true
            usernameBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            usernameExistsErrorMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            usernameExistsErrorMessage.leftAnchor.constraint(equalTo: usernameBottomLineView.leftAnchor).isActive = true
            usernameExistsErrorMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            usernameExistsErrorMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            restrictSpecialCharactersMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            restrictSpecialCharactersMessage.leftAnchor.constraint(equalTo: usernameBottomLineView.leftAnchor).isActive = true
            restrictSpecialCharactersMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            restrictSpecialCharactersMessage.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 25)
            nextButtonTopAnchor?.isActive = true
            nextButtonTopAnchorWithErrorShows = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 50)
            nextButtonTopAnchorWithErrorShows?.isActive = false
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 45).isActive = true
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameTextCount.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
            usernameTextCount.leftAnchor.constraint(equalTo: usernameTextField.rightAnchor, constant: -30).isActive = true
            usernameTextCount.widthAnchor.constraint(equalToConstant: 40).isActive = true
            usernameTextCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            usernameBottomLineView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
            usernameBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            usernameBottomLineView.widthAnchor.constraint(equalToConstant: 210).isActive = true
            usernameBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            usernameExistsErrorMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            usernameExistsErrorMessage.leftAnchor.constraint(equalTo: usernameBottomLineView.leftAnchor).isActive = true
            usernameExistsErrorMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            usernameExistsErrorMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            restrictSpecialCharactersMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
            restrictSpecialCharactersMessage.leftAnchor.constraint(equalTo: usernameBottomLineView.leftAnchor).isActive = true
            restrictSpecialCharactersMessage.widthAnchor.constraint(equalToConstant: 240).isActive = true
            restrictSpecialCharactersMessage.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 25)
            nextButtonTopAnchor?.isActive = true
            nextButtonTopAnchorWithErrorShows = nextButton.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 50)
            nextButtonTopAnchorWithErrorShows?.isActive = false
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            nextButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            signInButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
    }
}
