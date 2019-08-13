//
//  ChatListsViewController.swift
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

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView! = UITableView()
    
//    var user: UserModel?
    
    var User = [UserModel]()
    var Chat = [ChatModel]()
    var messageDictionary = [String: ChatModel]()
    
    var timer: Timer?
    
//    var chatPartnerUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(listCell.self, forCellReuseIdentifier: "listCell")
        
        view.addSubview(tableView)
        
        observeUserMessages()
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let message = self.Chat[indexPath.row]
        if let chatPartnerUid = message.chatPartnerUid() {
            Ref().databaseRoot.child("user-messages").child(uid).child(chatPartnerUid).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print("Failed to delete message: ", error!)
                    return
                }
                self.messageDictionary.removeValue(forKey: chatPartnerUid)
                self.attemptReloadTable()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! listCell
        let chat = Chat[indexPath.row]
        
        cell.lastMessageLabel.text = chat.text
        
        //if currentUid == toUid -> show senderUid
        //else show toUid
        if let chatPartnerUid = chat.chatPartnerUid() {
            Ref().databaseSpecificUser(uid: chatPartnerUid).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? [String:Any] {
                    let imageUrl = dict["profileImageUrl"] as? String
                    let username = dict["username"] as? String
                    let url = URL(string: imageUrl!)
                    
                    let user = UserModel()
                    user.setValuesForKeys(dict)
                    self.User.append(user)
                    
                    cell.nameLabel.text = username
                    cell.profileImage.kf.setImage(with: url)
                    cell.profileImage.layer.cornerRadius = 55/2
                    cell.profileImage.clipsToBounds = true
                    cell.profileImage.contentMode = .scaleAspectFill
                    
                    cell.timestamp(chat: chat)
                }
            })
        }
//        if currentUid == toUid {
//            chatPartnerUid = senderUid
//        } else {
//            chatPartnerUid = toUid
//        }
//        Ref().databaseSpecificUser(uid: chatPartnerUid!).observe(.value, with: { (snapshot) in
//            if let dict = snapshot.value as? [String:Any] {
//                let imageUrl = dict["profileImageUrl"] as? String
//                let username = dict["username"] as? String
//                let url = URL(string: imageUrl!)
//
//                let user = UserModel()
//                user.setValuesForKeys(dict)
//                self.User.append(user)
//
//                cell.nameLabel.text = username
//                cell.profileImage.kf.setImage(with: url)
//                cell.profileImage.layer.cornerRadius = 55/2
//                cell.profileImage.clipsToBounds = true
//                cell.profileImage.contentMode = .scaleAspectFill
//
//                cell.timestamp(chat: chat)
//            }
//        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = Chat[indexPath.row]
        if let chatPartnerUid = message.chatPartnerUid() {
            Ref().databaseSpecificUser(uid: chatPartnerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                self.User.removeAll()
                guard let dictionary = snapshot.value as? [String:Any] else {
                    return
                }
                let user = UserModel()
                user.setValuesForKeys(dictionary)
                self.User.append(user)
                self.performSegue(withIdentifier: "enterChatRoomSegue", sender: self)
                tableView.deselectRow(at: indexPath, animated: true)
            })
        }
//        if Auth.auth().currentUser?.uid == message.toUid {
//            chatPartnerUid = message.senderUid
//        } else {
//            chatPartnerUid = message.toUid
//        }
//        Ref().databaseSpecificUser(uid: chatPartnerUid!).observeSingleEvent(of: .value, with: { (snapshot) in
//            self.User.removeAll()
//            guard let dictionary = snapshot.value as? [String:Any] else {
//                return
//            }
//            let user = UserModel()
//            user.setValuesForKeys(dictionary)
//            self.User.append(user)
//            self.performSegue(withIdentifier: "enterChatRoomSegue", sender: self)
//            tableView.deselectRow(at: indexPath, animated: true)
//        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterChatRoomSegue" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! ChatViewController
            vc.userModel = self.User[0]
        }
    }
}

class listCell: UITableViewCell {
    
    let profileImage: UIImageView! = UIImageView()
    let nameLabel = UILabel()
    let lastMessageLabel = UILabel()
    let timestampLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(lastMessageLabel)
        addSubview(timestampLabel)
        
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        lastMessageLabel.font = UIFont.systemFont(ofSize: 14)
        lastMessageLabel.textColor = .lightGray
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        timestampLabel.textColor = .lightGray
        timestampLabel.font = UIFont.systemFont(ofSize: 13)
        timestampLabel.text = "HH:MM:SS"
        
        
        
        let constraints = [
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 16),
            lastMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            lastMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 83),
            lastMessageLabel.widthAnchor.constraint(equalToConstant: 250),
            
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profileImage.widthAnchor.constraint(equalToConstant: 55),
            profileImage.heightAnchor.constraint(equalToConstant: 55),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant:15),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 83),
            nameLabel.widthAnchor.constraint(equalToConstant: 250),
            
            timestampLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
