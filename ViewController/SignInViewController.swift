//
//  ViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class SignInViewController: UIViewController {
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "view_backgroundImage")
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.textAlignment = .center
        return label
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
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.textColor = .white
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = false
        
        button.setTitle("Sign In", for: UIControl.State.normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        return button
    }()
    
    var passwordResetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        
        button.setTitle("Forgot password?", for: UIControl.State.normal)
        button.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8), for: UIControl.State.normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(emailBottomLineView)
        view.addSubview(passwordBottomLineView)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(passwordResetButton)
        
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
        handleTextFields()
        didTapSignIn()
        didTapResetPassword()
        didTapSignUp()
    }
    
    func setDeviceUI() {
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" || UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus" {
            let title = "TIKI TALKA"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial-BoldItalicMT", size: 32)!
                ])
            titleLabel.attributedText = attributedText
            
            let emailPlaceholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = emailPlaceholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 16)
            
            let pwPlaceholderAttr = NSAttributedString(string: "Password", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            passwordTextField.attributedPlaceholder = pwPlaceholderAttr
            passwordTextField.font = UIFont.systemFont(ofSize: 16)
            
            let signUpTitle = "Don't have an account? "
            let subtitle = "Sign Up"
            let signUpAttributedText = NSMutableAttributedString(string: signUpTitle, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let attributedSubText = NSMutableAttributedString(string: subtitle, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
            signUpAttributedText.append(attributedSubText)
            signUpButton.setAttributedTitle(signUpAttributedText, for: UIControl.State.normal)
            
            passwordResetButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            signInButton.layer.cornerRadius = 19
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" || UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8" {
            let title = "TIKI TALKA"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial-BoldItalicMT", size: 28)!
                ])
            titleLabel.attributedText = attributedText
            
            let emailPlaceholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = emailPlaceholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 14)
            
            let pwPlaceholderAttr = NSAttributedString(string: "Password", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            passwordTextField.attributedPlaceholder = pwPlaceholderAttr
            passwordTextField.font = UIFont.systemFont(ofSize: 14)
            
            let signUpTitle = "Don't have an account? "
            let subtitle = "Sign Up"
            let signUpAttributedText = NSMutableAttributedString(string: signUpTitle, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let attributedSubText = NSMutableAttributedString(string: subtitle, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
            signUpAttributedText.append(attributedSubText)
            signUpButton.setAttributedTitle(signUpAttributedText, for: UIControl.State.normal)
            
            passwordResetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            
            signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            signInButton.layer.cornerRadius = 18
        } else {
            let title = "TIKI TALKA"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial-BoldItalicMT", size: 26)!
                ])
            titleLabel.attributedText = attributedText
            
            let emailPlaceholderAttr = NSAttributedString(string: "Email Address", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            emailTextField.attributedPlaceholder = emailPlaceholderAttr
            emailTextField.font = UIFont.systemFont(ofSize: 13)
            
            let pwPlaceholderAttr = NSAttributedString(string: "Password", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            passwordTextField.attributedPlaceholder = pwPlaceholderAttr
            passwordTextField.font = UIFont.systemFont(ofSize: 13)
            
            let signUpTitle = "Don't have an account? "
            let subtitle = "Sign Up"
            let signUpAttributedText = NSMutableAttributedString(string: signUpTitle, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11),
                 NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let attributedSubText = NSMutableAttributedString(string: subtitle, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 11),
                 NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
            signUpAttributedText.append(attributedSubText)
            signUpButton.setAttributedTitle(signUpAttributedText, for: UIControl.State.normal)
            
            passwordResetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            
            signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            signInButton.layer.cornerRadius = 17
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didTapSignIn() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSignIn))
        signInButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleSignIn() {
        self.view.endEditing(true)
        signIn(onSuccess: {
            let uid = Auth.auth().currentUser?.uid
            InstanceID.instanceID().instanceID { (result, error) in
                if let error = error {
                    print("Error fetching remote instance ID: \(error)")
                }else if let result = result{
                    Ref().databaseSpecificUser(uid: uid!).updateChildValues(["pushToken": result.token])
                }
            }
            self.performSegue(withIdentifier: "MainTabBarVC", sender: self)
        }) { (errorMessage) in
            ProgressHUD.showError("Please check email address or password")
        }
    }
    
    func didTapResetPassword() {
        passwordResetButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showResetPasswordVC))
        passwordResetButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func showResetPasswordVC() {
        self.performSegue(withIdentifier: "resetPasswordSegue", sender: self)
    }
    
    func didTapSignUp() {
        signUpButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSignUp))
        signUpButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleSignUp() {
        self.performSegue(withIdentifier: "createUsernameSegue", sender: self)
    }
}
