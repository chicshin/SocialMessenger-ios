//
//  ProfileImageTwoViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/30/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import ProgressHUD

class ProfileImageTwoViewController: UIViewController {
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "view_backgroundImage")
        return imageView
    }()
    
    var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        button.setTitle("Done", for: UIControl.State.normal)
        button.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        button.isHidden = true
        return button
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "defaultAvatar")
        imageView.layer.cornerRadius = 80/2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        let title = "Add Profile Picture"
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
        
        let title = "Add a profile photo so your friends know it's you. You can always change it later."
        let attributedSubText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!])
        label.attributedText = attributedSubText
        
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()

    var setImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = false
        
        button.setTitle("Add a profile image", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: UIControl.State.normal)
        
        button.layer.cornerRadius = 19
        button.backgroundColor = UIColor(white: 1, alpha: 0.2)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        button.setTitle("Skip", for: UIControl.State.normal)
        button.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.font = UIFont(name: "Arial-BoldMT", size: 28)
        label.text = "Welcome"
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.font = UIFont(name: "Arial-BoldMT", size: 28)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    var image : UIImage? = nil
    var usernameReceived = ""
    var blurBackground: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(usernameLabel)
        view.addSubview(doneButton)
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(setImageButton)
        view.addSubview(skipButton)
        
        setupUI()
        handleFunctions()
    }
    
    func setupUI() {
        setBlurBackground()
        setupConstraints()
    }
    
    func handleFunctions() {
        didTapSetImage()
        didTapDone()
        didTapSkip()
    }
    
    func didTapSetImage() {
//        setImageButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        setImageButton.addGestureRecognizer(tapGesture)
    }
    
    func didTapSkip() {
        skipButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSkip))
        skipButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleSkip() {
        image = #imageLiteral(resourceName: "defaultAvatar")
        loadWelcomeMessage()
        self.imageStorage(onSuccess: {
            self.performSegue(withIdentifier: "MainTabBarVC", sender: self)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    func didTapDone() {
        doneButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageStorage))
        doneButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleImageStorage() {
        loadWelcomeMessage()
        self.imageStorage(onSuccess: {
            self.performSegue(withIdentifier: "MainTabBarVC", sender: self)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }    
}

extension ProfileImageTwoViewController {
    func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurBackground = UIVisualEffectView(effect: blurEffect)
        blurBackground!.frame = view.bounds
        blurBackground!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurBackground!.alpha = 1
        view.addSubview(blurBackground!)
        view.addSubview(welcomeLabel)
        view.addSubview(usernameLabel)
        view.addSubview(doneButton)
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(setImageButton)
        view.addSubview(skipButton)
    }
    
    func loadWelcomeMessage() {
        usernameLabel.text = usernameReceived
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurBackground?.alpha = 0
            self.doneButton.alpha = 0
            self.profileImageView.alpha = 0
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.setImageButton.alpha = 0
            self.skipButton.alpha = 0
            self.welcomeLabel.alpha = 0.8
            self.usernameLabel.alpha = 0.8
            self.welcomeLabel.isHidden = false
            self.usernameLabel.isHidden = false
        }, completion: nil)
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imageStorage(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.ProfileImage(image: self.image, onSuccess: {
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
        
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 43).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 70).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitleLabel.widthAnchor.constraint(equalToConstant: 315).isActive = true
        
        setImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30).isActive = true
        setImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        setImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
//        welcomeUsernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
    }
}

extension ProfileImageTwoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[.originalImage] as? UIImage {
            image = imageSelected
            profileImageView.image = imageSelected
        }
        
        if let imageEdited = info[.editedImage] as? UIImage {
            image = imageEdited
            profileImageView.image = imageEdited
        }
        doneButton.isHidden = false
        dismiss(animated: true, completion: nil)
    }
}
