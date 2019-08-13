//
//  ChatListsViewController+UI.swift
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

extension ChatListViewController {
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        Ref().databaseRoot.child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
            self.User.removeAll()
//            self.messageDictionary.removeAll()
            let toUid = snapshot.key
            Ref().databaseRoot.child("user-messages").child(uid).child(toUid).observe(.childAdded, with: { (dataSanpshot) in
                let messageId = dataSanpshot.key
                Ref().databaseRoot.child("messages").child(messageId).observeSingleEvent(of: .value, with: { (messageSnapshot) in
                    if let dict = messageSnapshot.value as? [String:Any] {
                        let message = ChatModel(dictionary: dict)
//                        message.setValuesForKeys(dict)
                        self.Chat.append(message)

//                        if message.toUid == Auth.auth().currentUser?.uid {
//                            self.chatPartnerUid = message.senderUid
//                        } else {
//                            self.chatPartnerUid = message.toUid
//                        }
                        if let chatPartnerUid = message.chatPartnerUid() {
                            self.messageDictionary[chatPartnerUid] = message
                        }

//                        self.messageDictionary[self.chatPartnerUid!] = message
                    }
                    self.attemptReloadTable()
//                    self.Chat = Array(self.messageDictionary.values)
//                    self.Chat.sort(by: { (message1, message2) -> Bool in
//                        return message1.timestamp!.intValue > message2.timestamp!.intValue
//                    })
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData();
//                    }
                })
            })
        })
        Ref().databaseRoot.child("user-messages").child(uid).observe(.childRemoved, with: { (snapshot) in
            self.messageDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadTable()
        })
    }
    
    func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.Chat = Array(self.messageDictionary.values)
        self.Chat.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp!.intValue > message2.timestamp!.intValue
        })
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
        tableView.allowsMultipleSelection = true
    }
    
//    func fetchUser() {
//        let myUid = Auth.auth().currentUser?.uid
//        Ref().databaseUsers.observe(.value, with: { (snapshot) in
//            self.User.removeAll()
//            self.messageDictionary.removeAll()
//            let dict = snapshot.value as? [String:Any]
//            for child in dict!.keys {
//                if child != myUid && child != "activeUsernames" {
//                    let uid = child
//                    let user = UserModel()
//                    Ref().databaseUsers.child(uid).observe(.value, with: { (data) in
//                        if let dictionary = data.value as? [String:Any] {
//                            user.setValuesForKeys(dictionary)
//                            self.User.append(user)
//                        }
//                    })
//                }
//            }
//        })
//    }

}

