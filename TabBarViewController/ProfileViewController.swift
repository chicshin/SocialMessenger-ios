//
//  ProfileViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD
import Alamofire
import AlamofireImage
import CropViewController

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        button.tintColor = .black
        return button
    }()
    
    var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: UIControl.State.normal)
        button.tintColor = .lightGray
        button.titleLabel?.textAlignment = .right
        return button
    }()
    
    var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: UIControl.State.normal)
        button.tintColor = .darkGray
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var editImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "edit").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var addPhotoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    var addPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "add_photo").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    var statusTextField: UITextField = {
        let textField = UITextField()
        let placeholderAttr = NSMutableAttributedString(string: "Please type status", attributes:
            [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = placeholderAttr
        textField.textAlignment = .center
        return textField
    }()
    
    var textFieldUnderline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    var textCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .lightGray
        return label
    }()
    
    var blurBackground: UIVisualEffectView?
    var textFieldFrame: CGRect?
    var users = [UserModel]()
    var imageSelected: UIImage? = nil
    var statusText: String? = nil

    let imageView = UIImageView()
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTextField.delegate = self
        
        view.addSubview(closeButton)
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(statusLabel)
        view.addSubview(editButton)
        view.addSubview(editImage)
        view.addSubview(doneButton)
        view.addSubview(addPhotoView)
        view.addSubview(addPhotoImageView)
        view.addSubview(textFieldUnderline)
        view.addSubview(statusTextField)
        view.addSubview(textCountLabel)
        
        setUI()
        setupUI()
        tapRecognizerAction()
        
        textCountLabel.isHidden = true
        doneButton.isHidden = true
        addPhotoView.isHidden = true
        addPhotoImageView.isHidden = true
        statusTextField.isHidden = true
        textFieldUnderline.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    func setupUI() {
        setupProfileImage()
        setupFullname()
        setupStatusLabel()
    }
    
    func tapRecognizerAction() {
        didTapDismiss()
        didTapEditButton()
        didTapEditProfileImage()
        didTapTextField()
        didTapDone()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.removeBlurEffect()
    }
    
    func didTapDismiss() {
        closeButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        closeButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTapEditButton() {
        editButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editDidStart))
        editButton.addGestureRecognizer(tapGesture)
    }
    
    func didTapDone() {
        doneButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(saveChange))
        doneButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func saveChange() {
        self.view.endEditing(true)
        self.updateChangedValues()
        profileImage = imageView
        self.statusLabel.text = self.statusText
        self.imageStorage(onSuccess: {
        //changed image saved on database and storage
        }) { (errorMessage) in
        print("Something wrong1")
        ProgressHUD.showError(errorMessage)
        }
    
        statusLabel.isHidden = false
        editImage.isHidden = false
        editButton.isHidden = false
    
        addPhotoImageView.isHidden = true
        addPhotoView.isHidden = true
        statusTextField.isHidden = true
        textFieldUnderline.isHidden = true
        textCountLabel.isHidden = true
    
        doneButton.isHidden = true
    }
    
    func setUI() {
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) * 2 - 50).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImage.layer.cornerRadius = 100/2
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
            statusLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            statusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            statusLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            editButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            editButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
            
            editImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editImage.bottomAnchor.constraint(equalTo: editButton.topAnchor).isActive = true
            editImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
            editImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
            addPhotoView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: -25).isActive = true
            addPhotoView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -23).isActive = true
            addPhotoView.widthAnchor.constraint(equalToConstant: 28).isActive = true
            addPhotoView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            addPhotoView.layer.cornerRadius = 20/2
            
            addPhotoImageView.centerYAnchor.constraint(equalTo: addPhotoView.centerYAnchor).isActive = true
            addPhotoImageView.centerXAnchor.constraint(equalTo: addPhotoView.centerXAnchor).isActive = true
            addPhotoImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
            addPhotoImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
            
            textFieldUnderline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            textFieldUnderline.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3)).isActive = true
            textFieldUnderline.widthAnchor.constraint(equalToConstant: 250).isActive = true
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            statusTextField.centerXAnchor.constraint(equalTo: textFieldUnderline.centerXAnchor).isActive = true
            statusTextField.bottomAnchor.constraint(equalTo: textFieldUnderline.topAnchor, constant: -3).isActive = true
            statusTextField.widthAnchor.constraint(equalToConstant: 230).isActive = true
            statusTextField.font = UIFont(name: "KBIZforSMEsgo L", size: 15)
            
            textCountLabel.centerYAnchor.constraint(equalTo: statusTextField.centerYAnchor).isActive = true
            textCountLabel.leftAnchor.constraint(equalTo: textFieldUnderline.rightAnchor, constant: 25).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            textCountLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 13)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) * 2 - 50).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImage.layer.cornerRadius = 100/2
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
            statusLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            statusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            statusLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            editButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            editButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
            
            editImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editImage.bottomAnchor.constraint(equalTo: editButton.topAnchor).isActive = true
            editImage.widthAnchor.constraint(equalToConstant: 22).isActive = true
            editImage.heightAnchor.constraint(equalToConstant: 22).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
            addPhotoView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: -25).isActive = true
            addPhotoView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -23).isActive = true
            addPhotoView.widthAnchor.constraint(equalToConstant: 28).isActive = true
            addPhotoView.heightAnchor.constraint(equalToConstant: 28).isActive = true
            addPhotoView.layer.cornerRadius = 20/2
            
            addPhotoImageView.centerYAnchor.constraint(equalTo: addPhotoView.centerYAnchor).isActive = true
            addPhotoImageView.centerXAnchor.constraint(equalTo: addPhotoView.centerXAnchor).isActive = true
            addPhotoImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
            addPhotoImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
            
            textFieldUnderline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            textFieldUnderline.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3)).isActive = true
            textFieldUnderline.widthAnchor.constraint(equalToConstant: 250).isActive = true
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            statusTextField.centerXAnchor.constraint(equalTo: textFieldUnderline.centerXAnchor).isActive = true
            statusTextField.bottomAnchor.constraint(equalTo: textFieldUnderline.topAnchor, constant: -3).isActive = true
            statusTextField.widthAnchor.constraint(equalToConstant: 230).isActive = true
            statusTextField.font = UIFont(name: "KBIZforSMEsgo L", size: 15)
            
            textCountLabel.centerYAnchor.constraint(equalTo: statusTextField.centerYAnchor).isActive = true
            textCountLabel.leftAnchor.constraint(equalTo: textFieldUnderline.rightAnchor, constant: 25).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            textCountLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 13)
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) * 2 - 50).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
            profileImage.layer.cornerRadius = 90/2
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
            statusLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            statusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            statusLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
            editButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            editButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
            
            editImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editImage.bottomAnchor.constraint(equalTo: editButton.topAnchor).isActive = true
            editImage.widthAnchor.constraint(equalToConstant: 21).isActive = true
            editImage.heightAnchor.constraint(equalToConstant: 21).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
            addPhotoView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: -24).isActive = true
            addPhotoView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -22).isActive = true
            addPhotoView.widthAnchor.constraint(equalToConstant: 25).isActive = true
            addPhotoView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            addPhotoView.layer.cornerRadius = 20/2
            
            addPhotoImageView.centerYAnchor.constraint(equalTo: addPhotoView.centerYAnchor).isActive = true
            addPhotoImageView.centerXAnchor.constraint(equalTo: addPhotoView.centerXAnchor).isActive = true
            addPhotoImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            addPhotoImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            textFieldUnderline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            textFieldUnderline.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3)).isActive = true
            textFieldUnderline.widthAnchor.constraint(equalToConstant: 230).isActive = true
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            statusTextField.centerXAnchor.constraint(equalTo: textFieldUnderline.centerXAnchor).isActive = true
            statusTextField.bottomAnchor.constraint(equalTo: textFieldUnderline.topAnchor, constant: -3).isActive = true
            statusTextField.widthAnchor.constraint(equalToConstant: 210).isActive = true
            statusTextField.font = UIFont(name: "KBIZforSMEsgo L", size: 14)
            
            textCountLabel.centerYAnchor.constraint(equalTo: statusTextField.centerYAnchor).isActive = true
            textCountLabel.leftAnchor.constraint(equalTo: textFieldUnderline.rightAnchor, constant: 20).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            textCountLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 12)
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) * 2 - 50).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
            profileImage.layer.cornerRadius = 90/2
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
            statusLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            statusLabel.widthAnchor.constraint(equalToConstant: 290).isActive = true
            statusLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
            editButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            editButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
            
            editImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editImage.bottomAnchor.constraint(equalTo: editButton.topAnchor).isActive = true
            editImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
            editImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
            addPhotoView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: -24).isActive = true
            addPhotoView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -22).isActive = true
            addPhotoView.widthAnchor.constraint(equalToConstant: 25).isActive = true
            addPhotoView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            addPhotoView.layer.cornerRadius = 20/2
            
            addPhotoImageView.centerYAnchor.constraint(equalTo: addPhotoView.centerYAnchor).isActive = true
            addPhotoImageView.centerXAnchor.constraint(equalTo: addPhotoView.centerXAnchor).isActive = true
            addPhotoImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            addPhotoImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            textFieldUnderline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            textFieldUnderline.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3)).isActive = true
            textFieldUnderline.widthAnchor.constraint(equalToConstant: 230).isActive = true
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            statusTextField.centerXAnchor.constraint(equalTo: textFieldUnderline.centerXAnchor).isActive = true
            statusTextField.bottomAnchor.constraint(equalTo: textFieldUnderline.topAnchor, constant: -3).isActive = true
            statusTextField.widthAnchor.constraint(equalToConstant: 210).isActive = true
            statusTextField.font = UIFont(name: "KBIZforSMEsgo L", size: 14)
            
            textCountLabel.centerYAnchor.constraint(equalTo: statusTextField.centerYAnchor).isActive = true
            textCountLabel.leftAnchor.constraint(equalTo: textFieldUnderline.rightAnchor, constant: 20).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            textCountLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 12)
        } else {
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) * 2 - 50).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
            profileImage.layer.cornerRadius = 80/2
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 210).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
            statusLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            statusLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
            statusLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
            
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            editButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
            editButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
            
            editImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            editImage.bottomAnchor.constraint(equalTo: editButton.topAnchor).isActive = true
            editImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
            editImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            doneButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            addPhotoView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: -22).isActive = true
            addPhotoView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -20).isActive = true
            addPhotoView.widthAnchor.constraint(equalToConstant: 25).isActive = true
            addPhotoView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            addPhotoView.layer.cornerRadius = 20/2
            
            addPhotoImageView.centerYAnchor.constraint(equalTo: addPhotoView.centerYAnchor).isActive = true
            addPhotoImageView.centerXAnchor.constraint(equalTo: addPhotoView.centerXAnchor).isActive = true
            addPhotoImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            addPhotoImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            textFieldUnderline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            textFieldUnderline.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3)).isActive = true
            textFieldUnderline.widthAnchor.constraint(equalToConstant: 210).isActive = true
            textFieldUnderline.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            statusTextField.centerXAnchor.constraint(equalTo: textFieldUnderline.centerXAnchor).isActive = true
            statusTextField.bottomAnchor.constraint(equalTo: textFieldUnderline.topAnchor, constant: -3).isActive = true
            statusTextField.widthAnchor.constraint(equalToConstant: 190).isActive = true
            statusTextField.font = UIFont(name: "KBIZforSMEsgo L", size: 13)
            
            textCountLabel.centerYAnchor.constraint(equalTo: statusTextField.centerYAnchor).isActive = true
            textCountLabel.leftAnchor.constraint(equalTo: textFieldUnderline.rightAnchor, constant: 10).isActive = true
            textCountLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            textCountLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 12)
        }
    }
}
