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

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView! = UITableView()

    
    var User = [UserModel]()
    var AllUser = [AllUserModel]()
    var Chat = [ChatModel]()
    var messageDictionary = [String: ChatModel]()
    
    var timer: Timer?
    
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
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            return 67
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            return 65
            
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            return 66
            
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            return 59
            
        } else {
            return 57
        }
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
        
        let uid = Auth.auth().currentUser?.uid
        cell.messagesCountLabel.isHidden = true
        var unseenMessages = 0
        Ref().databaseRoot.child("user-messages").child(uid!).child(chat.senderUid!).observe(.childAdded, with: { (dataSanpshot) in
            let messageId = dataSanpshot.key
            Ref().databaseRoot.child("messages").child(messageId).observe(.value, with: { (messageSnapshot) in
                if let dict = messageSnapshot.value as? [String:Any] {
                    let read = dict["read"] as! Int
                    let toUid = dict["toUid"] as! String
                    if toUid == uid {
                        if read == 1 {
                            unseenMessages += 1
                            cell.messagesCountLabel.text = "\(unseenMessages)"
                            cell.messagesCountLabel.isHidden = false
                        }
                    }
                }
            })
        })
        setupCell(cell: cell, chat: chat)
        cell.chat = chat
        return cell
    }
    
    
    private func setupCell(cell: listCell, chat: ChatModel) {
        if chat.text != nil {
            cell.lastMessageLabel.text = chat.text
        } else {
            if chat.videoUrl != nil {
                cell.lastMessageLabel.text = "Sent a video"
            } else if chat.imageUrl != nil{
                cell.lastMessageLabel.text = "Sent an image"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = Chat[indexPath.row]
        if let chatPartnerUid = message.chatPartnerUid() {
            Ref().databaseSpecificUser(uid: chatPartnerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                self.User.removeAll()
                self.AllUser.removeAll()
                guard let dictionary = snapshot.value as? [String:Any] else {
                    return
                }
                let user = UserModel()
                user.setValuesForKeys(dictionary)
                self.User.append(user)
                
                let allUsers = AllUserModel()
                allUsers.setValuesForKeys(dictionary)
                self.AllUser.append(allUsers)
                
                self.performSegue(withIdentifier: "enterChatRoomSegue", sender: self)
                tableView.deselectRow(at: indexPath, animated: true)
            })
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterChatRoomSegue" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! ChatViewController
            vc.userModel = self.User[0]
            vc.allUser = self.AllUser[0]
        }
    }
}

class listCell: UITableViewCell {
    
    var chat: ChatModel? {
        didSet {
            if let chatPartnerUid = chat!.chatPartnerUid() {
                Ref().databaseSpecificUser(uid: chatPartnerUid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String:Any] {
                        let imageUrl = dict["profileImageUrl"] as? String
                        let username = dict["username"] as? String
                        let url = URL(string: imageUrl!)
                        
                        self.nameLabel.text = username
                        self.profileImage.kf.setImage(with: url)
                        self.profileImage.clipsToBounds = true
                        self.profileImage.contentMode = .scaleAspectFill
                        if self.chat!.datestampString() != self.chat!.today()! {
                            self.timestampLabel.text = self.chat!.datestampString()
                        } else {
                            self.timestampLabel.text = self.chat!.timestampString()
                        }
                    }
                })
            }
        }
    }
    
    let profileImage: UIImageView! = UIImageView()
    let nameLabel = UILabel()
    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        return label
    }()
    var messagesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = #colorLiteral(red: 0.6620325446, green: 0.0003923571203, blue: 0.05706844479, alpha: 1)
//        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(lastMessageLabel)
        addSubview(timestampLabel)
        addSubview(messagesCountLabel)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.text = "HH:MM:SS"
        
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            profileImage!.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage!.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            profileImage!.widthAnchor.constraint(equalToConstant: 50).isActive = true
            profileImage!.heightAnchor.constraint(equalToConstant: 50).isActive = true
            profileImage.layer.cornerRadius = 50/2
            
            lastMessageLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -5).isActive = true
            lastMessageLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            lastMessageLabel.widthAnchor.constraint(equalToConstant: 240).isActive = true
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
            lastMessageLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 14)
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
            nameLabel.font = UIFont(name: "Avenir-Medium", size: 17)
            
            timestampLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            timestampLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            timestampLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
            
            messagesCountLabel.centerYAnchor.constraint(equalTo: lastMessageLabel.centerYAnchor).isActive = true
            messagesCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            messagesCountLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
            messagesCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            messagesCountLabel.layer.cornerRadius = 20/2
            messagesCountLabel.font = UIFont.systemFont(ofSize: 10)
            
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            profileImage!.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage!.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            profileImage!.widthAnchor.constraint(equalToConstant: 49).isActive = true
            profileImage!.heightAnchor.constraint(equalToConstant: 49).isActive = true
            profileImage.layer.cornerRadius = 49/2
            
            lastMessageLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -5).isActive = true
            lastMessageLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            lastMessageLabel.widthAnchor.constraint(equalToConstant: 235).isActive = true
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
            lastMessageLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 14)
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
            nameLabel.font = UIFont(name: "Avenir-Medium", size: 17)
            
            timestampLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            timestampLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            timestampLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
            
            messagesCountLabel.centerYAnchor.constraint(equalTo: lastMessageLabel.centerYAnchor).isActive = true
            messagesCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            messagesCountLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
            messagesCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            messagesCountLabel.layer.cornerRadius = 20/2
            messagesCountLabel.font = UIFont.systemFont(ofSize: 10)
            
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            profileImage!.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage!.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            profileImage!.widthAnchor.constraint(equalToConstant: 47).isActive = true
            profileImage!.heightAnchor.constraint(equalToConstant: 47).isActive = true
            profileImage.layer.cornerRadius = 47/2
            
            lastMessageLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -5).isActive = true
            lastMessageLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            lastMessageLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
            lastMessageLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 13)
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
            nameLabel.font = UIFont(name: "Avenir-Medium", size: 15)
            
            timestampLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            timestampLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            timestampLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
            
            messagesCountLabel.centerYAnchor.constraint(equalTo: lastMessageLabel.centerYAnchor).isActive = true
            messagesCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            messagesCountLabel.widthAnchor.constraint(equalToConstant: 18).isActive = true
            messagesCountLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
            messagesCountLabel.layer.cornerRadius = 18/2
            messagesCountLabel.font = UIFont.systemFont(ofSize: 9)
            
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            profileImage!.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage!.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            profileImage!.widthAnchor.constraint(equalToConstant: 46).isActive = true
            profileImage!.heightAnchor.constraint(equalToConstant: 46).isActive = true
            profileImage.layer.cornerRadius = 46/2
            
            lastMessageLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -5).isActive = true
            lastMessageLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            lastMessageLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
            lastMessageLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 13)
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
            nameLabel.font = UIFont(name: "Avenir-Medium", size: 15)
            
            timestampLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            timestampLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            timestampLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
            
            messagesCountLabel.centerYAnchor.constraint(equalTo: lastMessageLabel.centerYAnchor).isActive = true
            messagesCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            messagesCountLabel.widthAnchor.constraint(equalToConstant: 18).isActive = true
            messagesCountLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
            messagesCountLabel.layer.cornerRadius = 18/2
            messagesCountLabel.font = UIFont.systemFont(ofSize: 9)
            
        } else {
            profileImage!.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage!.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            profileImage!.widthAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage!.heightAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.layer.cornerRadius = 45/2
            
            lastMessageLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: -5).isActive = true
            lastMessageLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            lastMessageLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
            lastMessageLabel.font = UIFont(name: "KBIZforSMEsgo L", size: 12)
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 5).isActive = true
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 15).isActive = true
            nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
            nameLabel.font = UIFont(name: "Avenir-Medium", size: 16)
            
            timestampLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
            timestampLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            timestampLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 11)
            
            messagesCountLabel.centerYAnchor.constraint(equalTo: lastMessageLabel.centerYAnchor).isActive = true
            messagesCountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            messagesCountLabel.widthAnchor.constraint(equalToConstant: 16).isActive = true
            messagesCountLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
            messagesCountLabel.layer.cornerRadius = 8
            messagesCountLabel.font = UIFont.systemFont(ofSize: 8)
        }
        
//        let constraints = [
//            lastMessageLabel.heightAnchor.constraint(equalToConstant: 16),
//            lastMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
//            lastMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 83),
//            lastMessageLabel.widthAnchor.constraint(equalToConstant: 250),
            
//            profileImage!.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
//            profileImage!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            profileImage!.widthAnchor.constraint(equalToConstant: 55),
//            profileImage!.heightAnchor.constraint(equalToConstant: 55),
            
//            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant:15),
//            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
//            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 83),
//            nameLabel.widthAnchor.constraint(equalToConstant: 250),
            
//            timestampLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
//            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
//            messagesCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//            messagesCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            messagesCountLabel.widthAnchor.constraint(equalToConstant: 20),
//            messagesCountLabel.heightAnchor.constraint(equalToConstant: 20)
//        ]
//        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
