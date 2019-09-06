//
//  DestinationProfileViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import AlamofireImage

class DestinationProfileViewController: UIViewController {
    
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
    
    var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send message", for: UIControl.State.normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var user: UserModel?
    var allUser: AllUserModel?
    var isSearching: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(closeButton)
        view.addSubview(chatButton)
        view.addSubview(statusLabel)
        setUI()
        setupUI()
    }
    
    func setupUI() {
//        setupChatButton()
        setupStatus()
        setupDestinationName()
        setupProfileImage()
        didTapDismiss()
        didTapMessage()
    }
    

    func didTapDismiss() {
        closeButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        closeButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTapMessage() {
        chatButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStartChat))
        chatButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleStartChat() {
        performSegue(withIdentifier: "chatRoomSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatRoomSegue" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! ChatViewController
            if isSearching! {
                vc.allUser = self.allUser
                vc.isSearching = true
            } else if !isSearching! {
                vc.userModel = self.user
                vc.isSearching = false
            }
        }
    }
    
    func setUI() {
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) * 2 - 50).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImage.layer.cornerRadius = 100/2
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 21)
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
            statusLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            statusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            statusLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            chatButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            chatButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
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
            
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            chatButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            chatButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: (UIScreen.main.bounds.height/3) * 2 - 50).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
            profileImage.layer.cornerRadius = 90/2
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true
            nameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 21)
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
            statusLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            statusLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
            statusLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
            chatButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            chatButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
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
            
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
            chatButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            chatButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
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
            
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
            chatButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
            chatButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
    }
}
