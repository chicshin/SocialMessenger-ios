//
//  SignInTwoViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/29/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class SignInTwoViewController: UIViewController {

//    @IBOutlet weak var emailContainerView: UIView!
//    @IBOutlet weak var passwordContainerView: UIView!
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "view_backgroundImage")
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let title = "TIKI TALKA"
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.init(name: "Arial-BoldItalicMT", size: 32)!
            ])
        label.attributedText = attributedText
        label.textColor = UIColor(white: 1, alpha: 0.8)
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
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        
        let placeholderAttr = NSAttributedString(string: "Password", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
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
    
    var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = false
        
        button.setTitle("Sign In", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)

        button.layer.cornerRadius = 19
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "Don't have an account? "
        let subtitle = "Sign Up"
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        let attributedSubText = NSMutableAttributedString(string: subtitle, attributes:
            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
             NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        
        attributedText.append(attributedSubText)
        button.setAttributedTitle(attributedText, for: UIControl.State.normal)
        
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        return button
    }()
    
    var passwordResetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        
        button.setTitle("Forgot password?", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
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
        
        setupUI()
        handleFunctions()
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
            self.performSegue(withIdentifier: "signInToTabBarVC", sender: self)
        }) { (errorMessage) in
            ProgressHUD.showError()
        }
    }
    
    func didTapResetPassword() {
        passwordResetButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showResetPasswordVC))
        passwordResetButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func showResetPasswordVC() {
        self.performSegue(withIdentifier: "resetPasswordTwoSegue", sender: self)
    }
    
    func didTapSignUp() {
        signUpButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSignUp))
        signUpButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleSignUp() {
        self.performSegue(withIdentifier: "createUsernameTwoSegue", sender: self)
    }
}

extension SignInTwoViewController {
    
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
    
    func setupConstraints() {
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        
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
    
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            onSuccess()
        }) {(errorMessage) in
            onError(errorMessage)
        }
    }
}
