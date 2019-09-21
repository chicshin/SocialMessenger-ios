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
    /* Control Flagged Users */
    func signOutFlaggedUserAlert() {
        let alert = UIAlertController(title: "Error", message: "Your account has been disabled for violating our terms.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.handleSignOut()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func handleSignOut() {
        let moreVC = MoreViewController()
        moreVC.removePushToken()
        do {
            try Auth.auth().signOut()
        } catch let logutError {
            print(logutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    
    
    
    func setupNavigationBar() {
        navigationItem.title = Auth.auth().currentUser?.displayName
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var blockedUsers = [String]()
        Ref().databaseRoot.child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
            let toUid = snapshot.key
            Ref().databaseRoot.child("user-messages").child(uid).child(toUid).observe(.childAdded, with: { (dataSanpshot) in
                let messageId = dataSanpshot.key
                Ref().databaseRoot.child("messages").child(messageId).observeSingleEvent(of: .value, with: { (messageSnapshot) in
                    if let dict = messageSnapshot.value as? [String:Any] {
                        let message = ChatModel(dictionary: dict)

                        if let chatPartnerUid = message.chatPartnerUid() {
                            self.messageDictionary[chatPartnerUid] = message
                            Ref().databaseRoot.child(FLAGGEDUSERS).observe(.value, with: { (snapshot) in
                                guard let dict = snapshot.value as? [String:Any] else {
                                    return
                                }
                                for key in dict.keys {
                                    if chatPartnerUid == key {
                                        self.messageDictionary.removeValue(forKey: chatPartnerUid)
                                        return
                                    } else {
                                        self.messageDictionary[chatPartnerUid] = message
                                    }
                                }
                                for item in blockedUsers {
                                    self.messageDictionary.removeValue(forKey: item)
                                    self.attemptReloadTable()
                                }

                            })
                        }
                        
                        self.attemptReloadTable()
                    }
                })
            })
        })
        
        Ref().databaseRoot.child(BLOCK).child(uid).child(BLOCKING).observe(.value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                return
            }
            for key in dict.keys {
                blockedUsers.append(key)
            }
        })
        
        Ref().databaseRoot.child(BLOCK).child(uid).child(BLOCKEDBY).observe(.value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                return
            }
            for key in dict.keys {
                blockedUsers.append(key)
            }
        })
        
        Ref().databaseRoot.child("user-messages").child(uid).observe(.childRemoved, with: { (snapshot) in
            self.messageDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadTable()
        })
    }
    
    func attemptReloadTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(handleReloadTable), userInfo: nil, repeats: false)
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
        tableView.allowsMultipleSelection = true
    }
}

