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
    
    func observeMessages() {
        Ref().databaseRoot.child("messages").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let message = ChatModel()
                message.setValuesForKeys(dict)
                self.Chat.append(message)
                if let toUid = message.toUid {
                    self.messageDictionary[toUid] = message
                    self.Chat = Array(self.messageDictionary.values)
                    self.Chat.sort(by: { (message1, message2) -> Bool in
                        return message1.timestamp!.intValue > message2.timestamp!.intValue
                    })
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                }
            }
        })
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
    }
    
    func fetchUser() {
        let myUid = Auth.auth().currentUser?.uid
        Ref().databaseUsers.observe(.value, with: { (snapshot) in
            self.User.removeAll()
            let dict = snapshot.value as? [String:Any]
            for child in dict!.keys {
                if child != myUid && child != "activeUsernames" {
                    let uid = child
                    let user = UserModel()
                    Ref().databaseUsers.child(uid).observe(.value, with: { (data) in
                        if let dictionary = data.value as? [String:Any] {
                            user.setValuesForKeys(dictionary)
                            self.User.append(user)
                        }
                    })
                }
            }
        })
//        Ref().databaseUsers.child(chat.toUid!).observe(.value, with: { (snapshot) in
//            self.User.removeAll()
//            if let dict = snapshot.value as? [String:Any] {
//                let user = UserModel()
//                user.setValuesForKeys(dict)
//                self.User.append(user)
//            }
//        })
    }
    
//    func setUsername(chat: ChatModel) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! listCell
//        let uid = chat.toUid!
//        Ref().databaseSpecificUser(uid: uid).observe(.value, with: { (snapshot) in
//            if let dict = snapshot.value as? [String:Any] {
//                cell.nameLabel.text = dict["username"] as? String
//            }
//        })
//    }

}
