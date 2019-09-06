//
//  SignUpViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "view_backgroundImage")
        return imageView
    }()
    
    var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        button.setImage(UIImage.init(named: "back_icon"), for: UIControl.State.normal)
        button.setTitle("Create Username", for: UIControl.State.normal)
        button.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
//        let title = "Email and Password"
//        let attributedText = NSMutableAttributedString(string: title, attributes:
//            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 29)])
//        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
//        let title = "Enter your name so friends may know it's you."
//        let attributedSubText = NSMutableAttributedString(string: title, attributes:
//            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!])
//        label.attributedText = attributedSubText
        
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    var fullnameBottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var emailBottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var passwordBottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var fullnameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        
//        let placeholderAttr = NSAttributedString(string: "Fullname", attributes:
//            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
//             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
//        textField.attributedPlaceholder = placeholderAttr
//
        textField.textColor = .white
//        textField.font = UIFont.systemFont(ofSize: 16)
        
        //        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        
//        let placeholderAttr = NSAttributedString(string: "Email Address", attributes:
//            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
//             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
//        textField.attributedPlaceholder = placeholderAttr
        
        textField.textColor = .white
//        textField.font = UIFont.systemFont(ofSize: 15)
        
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        
//        let placeholderAttr = NSAttributedString(string: "Password", attributes:
//            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
//             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
//        textField.attributedPlaceholder = placeholderAttr
//
        textField.textColor = .white
//        textField.font = UIFont.systemFont(ofSize: 16)
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = false
        
        button.setTitle("Create an account", for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
//
//        button.layer.cornerRadius = 19
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    var fullnameTextCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
//        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    var ageCheckBox: UIButton = {
        let button = UIButton(type: .system)
//        let checkedImage = UIImage(imageLiteralResourceName: "isChecked")
//        let uncheckedImage = UIImage(imageLiteralResourceName: "check")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "check"), for: UIControl.State.normal)
        button.setTitle("  I am +13 years old", for: UIControl.State.normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tintColor = .lightGray
        return button
    }()
    
    var isChecked = false
    
    var usernameReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
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
        
        fullnameTextField.delegate = self
        
        setDeviceUI()
        setupUI()
        handleFunctions()
    }
    
    func setupUI() {
        setBlurBackground()
        setupConstraints()
    }
    
    func handleFunctions() {
        didTapDismiss()
        handleTextFields()
        didTapCreateAccount()
        didTapAgeCheck()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didTapDismiss() {
        self.view.endEditing(true)
        dismissButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        dismissButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTapCreateAccount() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCreateDatabase))
        createAccountButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleCreateDatabase() {
        self.view.endEditing(true)
        signUp(onSuccess: {
            self.performSegue(withIdentifier: "ProfileImageSegue", sender: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    func didTapAgeCheck() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAgeCheckBox))
        ageCheckBox.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleAgeCheckBox() {
        isChecked = !isChecked
        let _ = isChecked == true ? ageCheckBox.setImage(#imageLiteral(resourceName: "isChecked"), for: UIControl.State.normal) : ageCheckBox.setImage(#imageLiteral(resourceName: "check"), for: UIControl.State.normal)
        
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
        } else {
            createAccountButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
            createAccountButton.layer.borderWidth = 2
            createAccountButton.layer.borderColor = UIColor.lightGray.cgColor
            createAccountButton.backgroundColor = .clear
            createAccountButton.isUserInteractionEnabled = false
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileImageSegue" {
            let vc = segue.destination as! ProfileImageViewController
            vc.usernameReceived = self.usernameReceived.lowercased()
        }
    }
    
    func setDeviceUI() {
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus" {
            let title = "Email and Password"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 29)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Enter your name so friends may know it's you."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Fullname", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            fullnameTextField.attributedPlaceholder = placeholderAttr
            fullnameTextField.font = UIFont.systemFont(ofSize: 15)
            
            let emailPlaceholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = emailPlaceholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 15)
            
            let pwPlaceholderAttr = NSAttributedString(string: "Password", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            passwordTextField.attributedPlaceholder = pwPlaceholderAttr
            passwordTextField.font = UIFont.systemFont(ofSize: 15)
            
            createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            createAccountButton.layer.cornerRadius = 19
            
            fullnameTextCount.font = UIFont.systemFont(ofSize: 12)
            ageCheckBox.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8" {
            let title = "Email and Password"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 26)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Enter your name so friends may know it's you."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 13)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Fullname", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            fullnameTextField.attributedPlaceholder = placeholderAttr
            fullnameTextField.font = UIFont.systemFont(ofSize: 15)
            
            let emailPlaceholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = emailPlaceholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 15)
            
            let pwPlaceholderAttr = NSAttributedString(string: "Password", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            passwordTextField.attributedPlaceholder = pwPlaceholderAttr
            passwordTextField.font = UIFont.systemFont(ofSize: 15)
            
            createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            createAccountButton.layer.cornerRadius = 17
            
            fullnameTextCount.font = UIFont.systemFont(ofSize: 11)
            ageCheckBox.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        } else {
            let title = "Email and Password"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Enter your name so friends may know it's you."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 13)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Fullname", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            fullnameTextField.attributedPlaceholder = placeholderAttr
            fullnameTextField.font = UIFont.systemFont(ofSize: 14)
            
            let emailPlaceholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = emailPlaceholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 14)
            
            let pwPlaceholderAttr = NSAttributedString(string: "Password", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            passwordTextField.attributedPlaceholder = pwPlaceholderAttr
            passwordTextField.font = UIFont.systemFont(ofSize: 14)
            
            createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            createAccountButton.layer.cornerRadius = 17
            
            fullnameTextCount.font = UIFont.systemFont(ofSize: 11)
            ageCheckBox.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            
            dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
    }
}
