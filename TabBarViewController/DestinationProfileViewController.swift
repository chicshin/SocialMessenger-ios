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
    var tableView = UITableView()
    var reportTableView = UITableView()
    var menuContents = ["Report User", "Block", "Follow"]
    let reportContents = ["Spam", "Fraud", "Inappropriate", "Other"]
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
    
    var chatImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "send").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    var chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send messages", for: UIControl.State.normal)
        button.titleLabel?.textAlignment = .center
        button.tintColor = .darkGray
        return button
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setImage(#imageLiteral(resourceName: "more_vertical"), for: UIControl.State.normal)
        return button
    }()
    
    let menuHeight: CGFloat = {
        var height = CGFloat()
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            height = 170
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            height = 170
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            height = 170
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            height = 150
        } else {
            height = 150
        }
        return height
    }()
    
    let reportMenuHeight: CGFloat = {
        var height = CGFloat()
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            height = 230
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            height = 230
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            height = 230
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            height = 220
        } else {
            height = 220
        }
        return height
    }()
    
    let menuWidth: CGFloat = {
        var width = CGFloat()
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            width = 364
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            width = 364
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            width = 355
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            width = 355
        } else {
            width = 300
        }
        return width
    }()

    var transparentView: UIView = UIView()
    var user: UserModel?
    var allUser: AllUserModel?
    var isSearching: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Block().observeFlaggedUser(completion: { (snapshot) in
            if snapshot {
                self.signOutFlaggedUserAlert()
            }
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DestinationSlideMenuCell.self, forCellReuseIdentifier: "DestinationSlideMenuCell")
        reportTableView.delegate = self
        reportTableView.dataSource = self
        reportTableView.register(ReportCell.self, forCellReuseIdentifier: "ReportCell")
        
        var counterUid: String?
        if self.isSearching! {
            counterUid = self.allUser!.uid!
        } else if !self.isSearching! {
            counterUid = self.user!.uid!
        }
        
        Block().observeBlockedUser(blockedUid: counterUid!, completion: { (snap) in
            if snap {
                self.menuContents[1] = "Unblock"
                self.menuContents.remove(at: 2)
            } else if !snap {
                self.menuContents[1] = "Block"
            }
        })
        
        UserRelationship().observeUnfollowedUser(unfollowedUid: counterUid!, completion: { (snap) in

            if snap {
                self.menuContents[2] = "Unfollow"
            } else if !snap {
                self.menuContents[2] = "Follow"
            }
        })
        
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(closeButton)
        view.addSubview(chatButton)
        view.addSubview(chatImage)
        view.addSubview(statusLabel)
        view.addSubview(moreButton)
        setUI()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    func setupUI() {
        setupTableView()
        setupStatus()
        setupDestinationName()
        setupProfileImage()
        didTapDismiss()
        didTapChatImage()
        didTapMessage()
        didTapMenu()
    }
    

    func didTapDismiss() {
        closeButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        closeButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTapChatImage() {
        chatImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStartChat))
        chatImage.addGestureRecognizer(tapGesture)
    }
    
    func didTapMessage() {
        chatButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStartChat))
        chatButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleStartChat() {
        performSegue(withIdentifier: "chatRoomSegue", sender: self)
    }
    
    func didTapMenu() {
        moreButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSlideMenuToggle))
        moreButton.addGestureRecognizer(tapGesture)
    }

    @objc func handleSlideMenuToggle() {
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        view.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: (screenSize.width - self.menuWidth) / 2, y: screenSize.height - self.menuHeight - 25, width: self.menuWidth, height: self.menuHeight)
        view.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: (screenSize.width - self.menuWidth) / 2, y: screenSize.height - self.menuHeight - 25, width: self.menuWidth, height: self.menuHeight)
        }, completion: nil)
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            let screenSize = UIScreen.main.bounds.size
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: (screenSize.width - self.menuWidth) / 2, y: screenSize.height, width: self.menuWidth, height: self.menuHeight)
        }, completion: nil)
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
            
            chatImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatImage.bottomAnchor.constraint(equalTo: chatButton.topAnchor, constant: 0).isActive = true
            chatImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            moreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
            moreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
            moreButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
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
            
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            chatButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            chatButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            chatImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatImage.bottomAnchor.constraint(equalTo: chatButton.topAnchor, constant: 0).isActive = true
            chatImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            moreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
            moreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
            moreButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
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
            
            chatImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatImage.bottomAnchor.constraint(equalTo: chatButton.topAnchor, constant: 0).isActive = true
            chatImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            moreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
            moreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            moreButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
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
            
            chatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
            chatButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
            chatButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            chatImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatImage.bottomAnchor.constraint(equalTo: chatButton.topAnchor, constant: 0).isActive = true
            chatImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            moreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
            moreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            moreButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
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
            
            chatImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            chatImage.bottomAnchor.constraint(equalTo: chatButton.topAnchor, constant: 0).isActive = true
            chatImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
            
            closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            moreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
            moreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            moreButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
    }

}

class DestinationSlideMenuCell: UITableViewCell {
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()

    var content: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
//            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
//        }
//        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
//            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
//        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
//            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
//        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
//            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
//        } else {
//            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
//        }
        label.textColor = .red
        return label
    }()

    let seperatorWidth: CGFloat = {
        var width = CGFloat()
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            width = 200
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            width = 200
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            width = 180
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            width = 150
        } else {
            width = 150
        }
        return width
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        addSubview(seperatorView)
        containerView.addSubview(content)
        
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalToConstant: seperatorWidth).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalToConstant: seperatorWidth).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalToConstant: seperatorWidth).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalToConstant: seperatorWidth).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
        } else {
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalToConstant: seperatorWidth).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReportCell: UITableViewCell {
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    var content: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        } else {
            label.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        }
        label.textColor = .red
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(containerView)
        addSubview(seperatorView)
        containerView.addSubview(content)
        
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 16)
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 15)
        } else {
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            seperatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            seperatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            
            content.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            content.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
            content.font = UIFont(name: "AppleSDGothicNeo-Light", size: 14)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DestinationProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == self.tableView {
            count = menuContents.count
        } else if tableView == self.reportTableView {
            count = reportContents.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationSlideMenuCell", for: indexPath) as! DestinationSlideMenuCell
            cell.seperatorView.isHidden = false
            let content = menuContents[indexPath.row]
            cell.content.text = content
            
            var counterUid: String?
            if self.isSearching! {
                counterUid = self.allUser!.uid!
            } else if !self.isSearching! {
                counterUid = self.user!.uid!
            }

            Block().observeBlockedUser(blockedUid: counterUid!, completion: { (snap) in
                if snap {
                    if indexPath.row == 1 {
                        self.menuContents[1] = "Unblock"
                        cell.content.text = "Unblock"
                    }
                } else if !snap {
                    if indexPath.row == 1 {
                        self.menuContents[1] = "Block"
                        cell.content.text = "Block"
                    }
                }
            })
            if menuContents.count == 3 {
                UserRelationship().observeUnfollowedUser(unfollowedUid: counterUid!, completion: { (snap) in
                    if snap {
                        if indexPath.row == 2 {
                            self.menuContents[2] = "Unfollow"
                            cell.content.text = "Unfollow"
                        }
                    } else if !snap {
                        if indexPath.row == 2 {
                            self.menuContents[2] = "Follow"
                            cell.content.text = "Follow"
                            cell.content.textColor = #colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1)
                        }
                    }
                })
            }
            
            setupCell(cell: cell, content: content)
            
            
            cellToReturn = cell
            
        } else if tableView == self.reportTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            let content = reportContents[indexPath.row]
            cell.seperatorView.isHidden = false
            cell.content.text = content
            setupReportCell(cell: cell, content: content)
            
            cellToReturn = cell
        }
        return cellToReturn
    }
    
    func setupCell(cell: DestinationSlideMenuCell, content: String) {
        if content == "Report User" {
            cell.seperatorView.isHidden = false
        } else if content == "Block" {
            cell.seperatorView.isHidden = false
        } else if content == "Unfollow" {
            cell.seperatorView.isHidden = true
        }
    }
    
    func setupReportCell(cell: ReportCell, content: String) {
        if content == "Spam" {
            cell.seperatorView.isHidden = false
        } else if content == "Fraud" {
            cell.seperatorView.isHidden = false
        } else if content == "Inappropriate" {
            cell.seperatorView.isHidden = false
        } else if content == "Other" {
            cell.seperatorView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if tableView == self.tableView {
            if menuContents.count == 2 {
                height = menuHeight/2
            } else {
                height = menuHeight/3
            }
        } else if tableView == self.reportTableView {
            height = reportMenuHeight/4
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            switch indexPath.row {
            case 0:
                self.tableView.removeFromSuperview()
                handleReportMenuToggle()
            case 1:
                self.tableView.removeFromSuperview()
                if menuContents[indexPath.row] == "Block" {
                    showBlockAlert()
                } else if menuContents[indexPath.row] == "Unblock" {
                    showUnblockAlert()
                }
            case 2:
                self.tableView.removeFromSuperview()
                self.tableView.reloadData()
                if menuContents[indexPath.row] == "Unfollow" {
                    showUnfollowAlert()
                } else if menuContents[indexPath.row] == "Follow" {
                    self.transparentView.removeFromSuperview()
                    var followUid: String?
                    var pushToken: String?
                    if self.isSearching! {
                        if self.allUser?.pushToken != nil {
                            pushToken = self.allUser!.pushToken!
                        }
                        followUid = self.allUser!.uid!
                        if self.allUser!.notifications!["newFollowers"] as! String == "enabled" && pushToken != nil {
                            UserRelationship().follow(followUid: followUid!, pushToken: pushToken!, isFCMOn: true)
                        } else {
                            UserRelationship().follow(followUid: followUid!, pushToken: "false", isFCMOn: false)
                        }
                        
                    } else if !self.isSearching! {
                        if self.user?.pushToken != nil {
                            pushToken = self.user!.pushToken!
                        }
                        followUid = self.user!.uid!
                        if self.user!.notifications!["newFollowers"] as! String == "enabled" && pushToken != nil {
                            UserRelationship().follow(followUid: followUid!, pushToken: pushToken!, isFCMOn: true)
                        } else {
                            UserRelationship().follow(followUid: followUid!, pushToken: "false", isFCMOn: false)
                        }
                    }
                }
            default:
                break
            }
            tableView.deselectRow(at: indexPath, animated: false)
        } else if tableView == self.reportTableView {
            switch indexPath.row {
            case 0:
                var uid: String?
                var flaggedEmail: String?
                if isSearching! {
                    uid = self.allUser!.uid!
                    flaggedEmail = self.allUser!.email!
                } else if !isSearching! {
                    uid = self.user!.uid!
                    flaggedEmail = self.user!.email!
                }
                Block().updateFlag(flagUser: uid!, reason: "spam", flaggedEmail: flaggedEmail!)
                dismissReportMenu()
            case 1:
                var uid: String?
                var flaggedEmail: String?
                if isSearching! {
                    uid = self.allUser!.uid!
                    flaggedEmail = self.allUser!.email!
                } else if !isSearching! {
                    uid = self.user!.uid!
                    flaggedEmail = self.user!.email!
                }
//                Block().updateFlag(flagUser: uid!, reason: "fraud")
                Block().updateFlag(flagUser: uid!, reason: "fraud", flaggedEmail: flaggedEmail!)
                dismissReportMenu()
            case 2:
                var uid: String?
                var flaggedEmail: String?
                if isSearching! {
                    uid = self.allUser!.uid!
                    flaggedEmail = self.allUser!.email!
                } else if !isSearching! {
                    uid = self.user!.uid!
                    flaggedEmail = self.user!.email!
                }
//                Block().updateFlag(flagUser: uid!, reason: "inappropriate")
                Block().updateFlag(flagUser: uid!, reason: "inappropriate", flaggedEmail: flaggedEmail!)
                dismissReportMenu()
            case 3:
                var uid: String?
                var flaggedEmail: String?
                if isSearching! {
                    uid = self.allUser!.uid!
                    flaggedEmail = self.allUser!.email!
                } else if !isSearching! {
                    uid = self.user!.uid!
                    flaggedEmail = self.user!.email!
                }
//                Block().updateFlag(flagUser: uid!, reason: "other")
                Block().updateFlag(flagUser: uid!, reason: "other", flaggedEmail: flaggedEmail!)
                dismissReportMenu()
            default:
                break
            }
            self.reportTableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func handleReportMenuToggle() {
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        view.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        reportTableView.frame = CGRect(x: (screenSize.width - self.menuWidth) / 2, y: screenSize.height - self.reportMenuHeight - 25, width: self.menuWidth, height: self.reportMenuHeight)
        view.addSubview(reportTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissReportMenu))
        transparentView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.reportTableView.frame = CGRect(x: (screenSize.width - self.menuWidth) / 2, y: screenSize.height - self.reportMenuHeight - 25, width: self.menuWidth, height: self.reportMenuHeight)
        }, completion: nil)
    }
    
    @objc func dismissReportMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            let screenSize = UIScreen.main.bounds.size
            self.transparentView.alpha = 0
            self.reportTableView.frame = CGRect(x: (screenSize.width - self.menuWidth) / 2, y: screenSize.height, width: self.menuWidth, height: self.reportMenuHeight)
        }, completion: nil)
    }
}
