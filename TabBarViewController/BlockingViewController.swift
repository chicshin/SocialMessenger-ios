//
//  BlockingViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 9/16/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class BlockingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView! = UITableView()
    var AllUsers = [AllUserModel]()
    var userDictionary = [String: AllUserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Block().observeFlaggedUser(completion: { (snapshot) in
            if snapshot {
                self.signOutFlaggedUserAlert()
            }
        })
        
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(blockingCell.self, forCellReuseIdentifier: "blockingCell")
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        navigationItem.title = "Blocked"
        setupUI()
        observeBlockedUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    func setupUI() {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            return 62
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            return 57
            
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            return 57
            
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            return 52
            
        } else {
            return 43
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockingCell", for: indexPath) as! blockingCell
        cell.selectionStyle = .none
        let user = AllUsers[indexPath.row]
        setupCell(cell: cell, user: user)
        cell.unblockButton.tag = indexPath.row
        didTapUnblock(cell: cell)
        return cell
    }
    
    func didTapUnblock(cell: blockingCell) {
        cell.unblockButton.isUserInteractionEnabled = true
        cell.unblockButton.addTarget(self, action: #selector(handleUnblock(sender:)), for: .touchUpInside)
    }
    
    @objc func handleUnblock(sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! blockingCell
        let uid = Auth.auth().currentUser?.uid
        let unblockUid = AllUsers[tag].uid
        let username = AllUsers[tag].username
        let alert = UIAlertController(title: "Unblock " + username! + "?", message: "They will now be able to send you messages. Tiki Talka won't notify them that you've unblocked them.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        alert.addAction(UIAlertAction(title: "Unblock", style: .default, handler: { (action: UIAlertAction!) in
            Block().unblockUser(uid: uid!, unblockUid: unblockUid!)
            cell.unblockButton.isHidden = true
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setupCell(cell: blockingCell, user: AllUserModel) {
        let url = URL(string: user.profileImageUrl!)
        cell.profileImage.kf.setImage(with: url)
        cell.usernameLabel.text = user.username!
        cell.profileImage.contentMode = .scaleAspectFill
    }
    
}

class blockingCell: UITableViewCell {
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    let unblockButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
//        button.setImage(#imageLiteral(resourceName: "block").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle("Unblock", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(unblockButton)
        
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
            profileImage.layer.cornerRadius = 50/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
            unblockButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            unblockButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            unblockButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            unblockButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
            unblockButton.layer.cornerRadius = 15
            unblockButton.clipsToBounds = true
            unblockButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.layer.cornerRadius = 45/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            unblockButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            unblockButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            unblockButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            unblockButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
            unblockButton.layer.cornerRadius = 15
            unblockButton.clipsToBounds = true
            unblockButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)

            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.layer.cornerRadius = 45/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
            unblockButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            unblockButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            unblockButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            unblockButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
            unblockButton.layer.cornerRadius = 15
            unblockButton.clipsToBounds = true
            unblockButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
            
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
            profileImage.layer.cornerRadius = 40/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
            unblockButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            unblockButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            unblockButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            unblockButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
            unblockButton.layer.cornerRadius = 15
            unblockButton.clipsToBounds = true
            unblockButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
            
        } else {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
            profileImage.layer.cornerRadius = 35/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
            
            unblockButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            unblockButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            unblockButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
            unblockButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
            unblockButton.layer.cornerRadius = 15
            unblockButton.clipsToBounds = true
            unblockButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
    
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
