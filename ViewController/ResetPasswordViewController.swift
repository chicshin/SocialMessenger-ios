//
//  ResetPasswordViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/4/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import ProgressHUD

class ResetPasswordViewController: UIViewController {
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "view_backgroundImage")
        return imageView
    }()
    
    var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage.init(named: "close_icon"), for: UIControl.State.normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.7)
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 3
        return label
    }()
    
    var emailBottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear

        textField.borderStyle = .none
        textField.textColor = .white
        
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    var resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = false
        
        button.setTitle("Request Reset Link", for: UIControl.State.normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailBottomLineView)
        view.addSubview(resetButton)
        view.addSubview(dismissButton)
        
        setDeviceUI()
        setupUI()
        handleFunctions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    func setupUI() {
        setBlurBackground()
        setupConstraints()
    }
    
    func handleFunctions() {
        didTapDismiss()
        handleTextField()
        didTapRequestLink()
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
    
    func didTapRequestLink() {
        self.validateFields()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleResetButton))
        resetButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleResetButton() {
        Api.User.resetPassword(email: self.emailTextField.text!, onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess(SUCCESS_EMAIL_RESET)
            self.navigationController?.popViewController(animated: true)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    func setDeviceUI() {
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" || UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus" {
            let title = "Reset Password"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Enter your email address you're are using for your account. We will send a password reset link."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 15)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = placeholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 16)
            
            resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            resetButton.layer.cornerRadius = 19
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" || UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8" {
            let title = "Reset Password"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 26)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Enter your email address you're are using for your account. We will send a password reset link."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = placeholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 13)
            
            resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            resetButton.layer.cornerRadius = 17
        } else {
            let title = "Reset Password"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Enter your email address you're are using for your account. We will send a password reset link."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 13)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = placeholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 12)
            
            resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            resetButton.layer.cornerRadius = 17
        }
    }
}
