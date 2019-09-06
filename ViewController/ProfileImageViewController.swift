//
//  ProfileImageViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import ProgressHUD
import CropViewController


class ProfileImageViewController: UIViewController {
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
//        let title = "Add Profile Picture"
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
        
//        let title = "Add a profile photo so your friends know it's you. You can always change it later."
//        let attributedSubText = NSMutableAttributedString(string: title, attributes:
//            [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!])
//        label.attributedText = attributedSubText
        
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
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: UIControl.State.normal)
        
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        button.layer.cornerRadius = 19
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
//        label.font = UIFont(name: "Arial-BoldMT", size: 26)
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
//        label.font = UIFont(name: "Arial-BoldMT", size: 26)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    var image : UIImage? = nil
    var usernameReceived = ""
    var blurBackground: UIVisualEffectView?
    
    let imageView = UIImageView()
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    
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
        
        setDeviceUI()
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
        image = #imageLiteral(resourceName: "view_backgroundImage")
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
    
    func setDeviceUI() {
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" || UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus" {
            let title = "Add Profile Picture"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 29)])
            titleLabel.attributedText = attributedText
            
            let sutTitle = "Add a profile photo so your friends know it's you. You can always change it later."
            let attributedSubText = NSMutableAttributedString(string: sutTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 14)!])
            subtitleLabel.attributedText = attributedSubText
            
            setImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            setImageButton.layer.cornerRadius = 19
            
            welcomeLabel.font = UIFont(name: "Arial-BoldMT", size: 26)
            usernameLabel.font = UIFont(name: "Arial-BoldMT", size: 26)
            
            doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            profileImageView.layer.cornerRadius = 80/2
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" || UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8" {
            let title = "Add Profile Picture"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)])
            titleLabel.attributedText = attributedText
            
            let sutTitle = "Add a profile photo so your friends know it's you. You can always change it later."
            let attributedSubText = NSMutableAttributedString(string: sutTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 13)!])
            subtitleLabel.attributedText = attributedSubText
            
            setImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            setImageButton.layer.cornerRadius = 17
            
            welcomeLabel.font = UIFont(name: "Arial-BoldMT", size: 24)
            usernameLabel.font = UIFont(name: "Arial-BoldMT", size: 24)
            
            doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            profileImageView.layer.cornerRadius = 80/2
        } else {
            let title = "Add Profile Picture"
            let attributedText = NSMutableAttributedString(string: title, attributes:
                [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
            titleLabel.attributedText = attributedText
            
            let sutTitle = "Add a profile photo so your friends know it's you. You can always change it later."
            let attributedSubText = NSMutableAttributedString(string: sutTitle, attributes:
                [NSAttributedString.Key.font : UIFont.init(name: "Arial", size: 13)!])
            subtitleLabel.attributedText = attributedSubText
            
            setImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            setImageButton.layer.cornerRadius = 17
            
            welcomeLabel.font = UIFont(name: "Arial-BoldMT", size: 22)
            usernameLabel.font = UIFont(name: "Arial-BoldMT", size: 22)
            
            doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            profileImageView.layer.cornerRadius = 70/2
        }
    }
}
