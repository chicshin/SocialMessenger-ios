//
//  SignUpTwoViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/30/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

class SignUpTwoViewController: UIViewController, UITextFieldDelegate {
//    @IBOutlet weak var createAccountButton: UIButton!
//    @IBOutlet weak var backButton: UIButton!
//    @IBOutlet weak var restrictCharactersLabel: UILabel!
//    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var createButtonTopLayout: NSLayoutConstraint!
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
        
        let title = "Email and Password"
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 29)])
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        let title = "Enter your name so friends may know it's you."
        let attributedSubText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!])
        label.attributedText = attributedSubText
        
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
        
        let placeholderAttr = NSAttributedString(string: "Fullname", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
        textField.attributedPlaceholder = placeholderAttr
        
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        
//        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        
        let placeholderAttr = NSAttributedString(string: "Email Address", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
        textField.attributedPlaceholder = placeholderAttr
        
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 15)
        
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
        
        let placeholderAttr = NSAttributedString(string: "Password", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
        textField.attributedPlaceholder = placeholderAttr
        
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    var fullnameTextCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
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
        
        fullnameTextField.delegate = self
        
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
    
}

extension SignUpTwoViewController {
    func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1
        view.addSubview(blurEffectView)
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(fullnameTextField)
//        fullnameTextField.addSubview(fullnameTextCount)
        view.addSubview(fullnameTextCount)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(fullnameBottomLineView)
        view.addSubview(emailBottomLineView)
        view.addSubview(passwordBottomLineView)
        view.addSubview(createAccountButton)
    }
    
    func handleTextFields() {
        fullnameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let fullname = fullnameTextField.text, !fullname.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            createAccountButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
            createAccountButton.layer.borderWidth = 2
            createAccountButton.layer.borderColor = UIColor.lightGray.cgColor
            createAccountButton.backgroundColor = .clear
            createAccountButton.isUserInteractionEnabled = false
            return
        }
        createAccountButton.setTitleColor(.white, for: UIControl.State.normal)
        createAccountButton.layer.borderWidth = 0
        createAccountButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        createAccountButton.isUserInteractionEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = self.fullnameTextField.text!.count + string.utf16.count - range.length
        fullnameTextCount.isHidden = false
        if length == 0 {
            fullnameTextCount.isHidden = true
        }
        if length <= 25 {
            self.fullnameTextCount.text = "\(length)/25"
            return true
        } else {
            print("text count out of range")
            return false
        }
    }
    
    func setupConstraints() {
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 43).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: dismissButton.topAnchor, constant: 80).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 315).isActive = true
        
        fullnameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20).isActive = true
        fullnameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -25).isActive = true
        fullnameTextField.widthAnchor.constraint(equalToConstant: 220).isActive = true
        fullnameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        fullnameTextCount.centerYAnchor.constraint(equalTo: fullnameTextField.centerYAnchor).isActive = true
        fullnameTextCount.leftAnchor.constraint(equalTo: fullnameTextField.rightAnchor, constant: 5).isActive = true
        fullnameTextCount.widthAnchor.constraint(equalToConstant: 50).isActive = true
        fullnameTextCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        fullnameBottomLineView.topAnchor.constraint(equalTo: fullnameTextField.bottomAnchor).isActive = true
        fullnameBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fullnameBottomLineView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        fullnameBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: fullnameTextField.bottomAnchor, constant: 20).isActive = true
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
        
        createAccountButton.topAnchor.constraint(equalTo: passwordBottomLineView.bottomAnchor, constant: 30).isActive = true
        createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createAccountButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        createAccountButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
