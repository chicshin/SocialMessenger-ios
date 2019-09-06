//
//  SignUpViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
class CreateUsernameViewController: UIViewController, UITextFieldDelegate {
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
        
//        let title = "Create Username"
//        let attributedText = NSMutableAttributedString(string: title, attributes:
//            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])
//        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.textColor = .lightGray
        //        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
//        let title = "Pick a username for your account. You can always change it later."
//        let attributedSubText = NSMutableAttributedString(string: title, attributes:
//            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 15)!])
//        label.attributedText = attributedSubText
        
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
        
//        let placeholderAttr = NSAttributedString(string: "Enter username", attributes:
//            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
//             NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        textField.borderStyle = .none
//        textField.attributedPlaceholder = placeholderAttr
        
        textField.textAlignment = .center
        textField.textColor = .white
//        textField.font = UIFont.systemFont(ofSize: 16)
        
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
        
//        let message = "Only numbers, letters and underscore(_) are allowed in the username."
//        let attributedText = NSMutableAttributedString(string: message, attributes:
//            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
//             NSAttributedString.Key.foregroundColor : UIColor.red])
//
//        label.attributedText = attributedText
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
//        button.layer.cornerRadius = 19
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    var signInButton: UIButton = {
        let button = UIButton(type: .system)
//        let title = "Already have an account? "
//        let subtitle = "Sign In"
//        let attributedText = NSMutableAttributedString(string: title, attributes:
//            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
//             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
//        let attributedSubText = NSMutableAttributedString(string: subtitle, attributes:
//            [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
//             NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        
//        attributedText.append(attributedSubText)
//        button.setAttributedTitle(attributedText, for: UIControl.State.normal)
        
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        return button
    }()
    
    var usernameTextCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
//        label.font = UIFont.systemFont(ofSize: 12)
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
        
        setDeviceUI()
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
            let vc = segue.destination as! SignUpViewController
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
    
    func setDeviceUI() {
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus" {
            let title = "Create Username"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Pick a username for your account. You can always change it later."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 15)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Enter username", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            usernameTextField.attributedPlaceholder = placeholderAttr
            usernameTextField.font = UIFont.systemFont(ofSize: 16)
            
            let message = "Only numbers, letters and underscore(_) are allowed in the username."
            let errorAttributedText = NSMutableAttributedString(string: message, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.red])
            
            restrictSpecialCharactersMessage.attributedText = errorAttributedText
            
            nextButton.layer.cornerRadius = 19
            nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            let signInTitle = "Already have an account? "
            let signInSubtitle = "Sign In"
            let signInAttributedText = NSMutableAttributedString(string: signInTitle, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let signInAttributedSubText = NSMutableAttributedString(string: signInSubtitle, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
            signInAttributedText.append(signInAttributedSubText)
            signInButton.setAttributedTitle(signInAttributedText, for: UIControl.State.normal)
            
            usernameTextCount.font = UIFont.systemFont(ofSize: 12)
            
            let usernameExistMessage = "Username " + usernameSelected + " is already taken."
            let existErrorAttributedText = NSMutableAttributedString(string: usernameExistMessage, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.red])
            usernameExistsErrorMessage.attributedText = existErrorAttributedText
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8" {
            let title = "Create Username"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 26)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Pick a username for your account. You can always change it later."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 15)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Enter username", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            usernameTextField.attributedPlaceholder = placeholderAttr
            usernameTextField.font = UIFont.systemFont(ofSize: 15)
            
            let message = "Only numbers, letters and underscore(_) are allowed in the username."
            let errorAttributedText = NSMutableAttributedString(string: message, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.red])
            
            restrictSpecialCharactersMessage.attributedText = errorAttributedText
            
            nextButton.layer.cornerRadius = 17
            nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            let signInTitle = "Already have an account? "
            let signInSubtitle = "Sign In"
            let signInAttributedText = NSMutableAttributedString(string: signInTitle, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let signInAttributedSubText = NSMutableAttributedString(string: signInSubtitle, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
            signInAttributedText.append(signInAttributedSubText)
            signInButton.setAttributedTitle(signInAttributedText, for: UIControl.State.normal)
            
            usernameTextCount.font = UIFont.systemFont(ofSize: 12)
            
            let usernameExistMessage = "Username " + usernameSelected + " is already taken."
            let existErrorAttributedText = NSMutableAttributedString(string: usernameExistMessage, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.red])
            usernameExistsErrorMessage.attributedText = existErrorAttributedText
        } else {
            let title = "Create Username"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
            titleLabel.attributedText = attributedText
            
            let subTitle = "Pick a username for your account. You can always change it later."
            let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!])
            subtitleLabel.attributedText = attributedSubText
            
            let placeholderAttr = NSAttributedString(string: "Enter username", attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                 NSAttributedString.Key.foregroundColor : UIColor.darkGray])
            usernameTextField.attributedPlaceholder = placeholderAttr
            usernameTextField.font = UIFont.systemFont(ofSize: 14)
            
            let message = "Only numbers, letters and underscore(_) are allowed in the username."
            let errorAttributedText = NSMutableAttributedString(string: message, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11),
                 NSAttributedString.Key.foregroundColor : UIColor.red])
            
            restrictSpecialCharactersMessage.attributedText = errorAttributedText
            
            nextButton.layer.cornerRadius = 17
            nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            let signInTitle = "Already have an account? "
            let signInSubtitle = "Sign In"
            let signInAttributedText = NSMutableAttributedString(string: signInTitle, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            let signInAttributedSubText = NSMutableAttributedString(string: signInSubtitle, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12),
                 NSAttributedString.Key.foregroundColor : UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.8)])
            signInAttributedText.append(signInAttributedSubText)
            signInButton.setAttributedTitle(signInAttributedText, for: UIControl.State.normal)
            
            usernameTextCount.font = UIFont.systemFont(ofSize: 12)
            
            let usernameExistMessage = "Username " + usernameSelected + " is already taken."
            let existErrorAttributedText = NSMutableAttributedString(string: usernameExistMessage, attributes:
                [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11),
                 NSAttributedString.Key.foregroundColor : UIColor.red])
            usernameExistsErrorMessage.attributedText = existErrorAttributedText
        }
    }
}
