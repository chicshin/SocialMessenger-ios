//
//  ResetPasswordTwoViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/29/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import ProgressHUD

class ResetPasswordTwoViewController: UIViewController {
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
//        button.clipsToBounds = true
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        let title = "Reset Password"
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.textColor = .lightGray
//        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        let title = "Enter your email address you're are using for your account below. We will send a password reset link."
        let attributedSubText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 15)!])
        label.attributedText = attributedSubText
        
        label.textAlignment = .center
        label.textColor = .lightGray
//        label.textColor = UIColor(white: 1, alpha: 0.8)
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
        
        let placeholderAttr = NSAttributedString(string: "Email Address", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
        textField.attributedPlaceholder = placeholderAttr
        
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        
        button.layer.cornerRadius = 19
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
        
        setupUI()
        handleFunctions()
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
}

extension ResetPasswordTwoViewController {
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
