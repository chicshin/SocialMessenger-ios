//
//  CreateUsernameTwoViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/29/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit

class CreateUsernameTwoViewController: UIViewController, UITextFieldDelegate {
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "view_backgroundImage")
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        let title = "Create Username"
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
        
        let title = "Pick a username for your account. You can always change it later."
        let attributedSubText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 15)!])
        label.attributedText = attributedSubText
        
        label.textAlignment = .center
        label.textColor = .lightGray
        //        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.numberOfLines = 3
        return label
    }()
    
    var usernameBottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        
        let placeholderAttr = NSAttributedString(string: "Enter username", attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
        textField.attributedPlaceholder = placeholderAttr
        
        textField.textAlignment = .center
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }()
    
    var usernameExistsErrorMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var restrictSpecialCharactersMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let message = "Only numbers, letters and underscore(_) are allowed in the username."
        let attributedText = NSMutableAttributedString(string: message, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor : UIColor.red])
        
        label.attributedText = attributedText
        //        restrictSpecialCharactersMessageLabel.isHidden = false
        label.numberOfLines = 2
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = false
        
        button.setTitle("Next", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        
        button.layer.cornerRadius = 19
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    var signInButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "Already have an account? "
        let subtitle = "Sign In"
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
    
    var usernameTextCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    var nextButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchorWithErrorShows: NSLayoutConstraint?
    var usernameSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(usernameTextCount)
        view.addSubview(usernameBottomLineView)
        view.addSubview(usernameExistsErrorMessage)
        view.addSubview(restrictSpecialCharactersMessage)
        view.addSubview(nextButton)
        view.addSubview(signInButton)
        
        usernameTextField.delegate = self

        setupUI()
        handleFunctions()
    }
    
    func setupUI() {
        setBlurBackground()
        setupConstraints()
    }
    
    func handleFunctions() {
        handleTextFields()
        dismissError()
        didTapNextButton()
        didTapSignIn()
    }
    
    func didTapNextButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCreateUsername))
        nextButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleCreateUsername() {
        self.view.endEditing(true)
        self.usernameSelected = usernameTextField.text!
        createUsername(onSuccess: {
            self.performSegue(withIdentifier: "signUpSegue", sender: self)
        }) { (errorMessage) in
            self.setupErrorLabel()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUpSegue" {
            let vc = segue.destination as! SignUpTwoViewController
            vc.usernameReceived = self.usernameSelected.lowercased()
        }
    }
    
    func didTapSignIn() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSignInVC))
        signInButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func showSignInVC() {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
}

extension CreateUsernameTwoViewController {
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
    
    func setupErrorLabel() {
        let message = "Username " + usernameSelected + " is already taken."
        let attributedText = NSMutableAttributedString(string: message, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor : UIColor.red])
        
        usernameExistsErrorMessage.attributedText = attributedText
        usernameExistsErrorMessage.isHidden = false
        nextButtonTopAnchorWithErrorShows?.isActive = true
        nextButtonTopAnchor?.isActive = false
    }
    
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

        if string == filtered && length <= 20 {
            restrictSpecialCharactersMessage.isHidden = true
            nextButtonTopAnchorWithErrorShows?.isActive = false
            nextButtonTopAnchor?.isActive = true
            nextButton.isUserInteractionEnabled = true
            self.usernameTextCount.text = "\(length)/20"
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
        
//        if length == 0 {
//            usernameTextCount.isHidden = true
//        }
//        if length <= 25 {
//            self.usernameTextCount.text = "\(length)/25"
//            return true
//        } else {
//            print("text count out of range")
//            return false
//        }
    }
    
    func dismissError() {
        usernameExistsErrorMessage.isHidden = true
        restrictSpecialCharactersMessage.isHidden = true
        nextButtonTopAnchorWithErrorShows?.isActive = false
        nextButtonTopAnchor?.isActive = true
    }
    
    func createUsername(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.createUsername(withUsername: usernameTextField.text!, onSuccess: {
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
    
    func setupConstraints() {
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 45).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: 240).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        usernameTextCount.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
        usernameTextCount.leftAnchor.constraint(equalTo: usernameTextField.rightAnchor, constant: 10).isActive = true
        usernameTextCount.widthAnchor.constraint(equalToConstant: 40).isActive = true
        usernameTextCount.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        usernameBottomLineView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameBottomLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameBottomLineView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        usernameBottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        usernameExistsErrorMessage.topAnchor.constraint(equalTo: usernameBottomLineView.bottomAnchor, constant: 5).isActive = true
        usernameExistsErrorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
}
