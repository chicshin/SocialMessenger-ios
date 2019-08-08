//
//  PeopleViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

extension PeopleViewController {
    
    func loadMyProfile() {
        let uid = Auth.auth().currentUser?.uid
        
        Ref().databaseUsers.child(uid!).observe(.value, with: { (snapshot: DataSnapshot) in
            self.currentUser.removeAll()
            if let dict = snapshot.value as? [String:Any] {
                let username = dict["username"] as! String
                let profileImageUrlString = dict["profileImageUrl"] as! String
                let uid = dict["uid"] as! String
                let user = CurrentUserModel(username: username, profileImageUrlString: profileImageUrlString, uid: uid)
                self.currentUser.append(user)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        })
    }
    func loadPeople() {
        let myUid = Auth.auth().currentUser?.uid
        Ref().databaseUsers.observe(.value, with: { (snapshot: DataSnapshot) in
            self.Users.removeAll()
            let dict = snapshot.value as? [String:Any]
            var uids = ""
            for child in dict!.keys {
                if child != myUid && child != "activeUsernames"{
                    uids = child
                    Ref().databaseUsers.child(uids).observe(.value, with: { (data: DataSnapshot) in
                        if let dictTemp = data.value as? [String:Any] {
                            let username = dictTemp["username"] as! String
                            let profileImageUrlString = dictTemp["profileImageUrl"] as! String
                            let uid = dictTemp["uid"] as! String
                            let user = UserModel(username: username, profileImageUrlString: profileImageUrlString, uid: uid)
                            self.Users.append(user)
                        }
                        DispatchQueue.main.async {
                            self.friendsTableView.reloadData();
                        }
                    })
                }
            }
        })
//        Ref().databaseUsers.observe(.childAdded, with: { (snapshot) in
////            print(snapshot.value)
//            if let dict = snapshot.value as? [String:AnyObject] {
//                let user = UserModel()
////                user.setValuesForKeys(dict)
//                user.username = dict["username"] as? String
//                user.fullname = dict["fullname"] as? String
//                user.profileImageUrl = dict["profileImageUrl"] as? String
//                user.uid = dict["uid"] as? String
//                user.email = dict["email"] as? String
//                
//
//                self.Users.append(user)
//                DispatchQueue.main.async {
//                    self.friendsTableView.reloadData();
//                }
//            }
//        })

    }
    
    func setupImage() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! MyCell
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.clipsToBounds = true
        
    }
    
    func setupFriendsImage() {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.clipsToBounds = true
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        friendsTableView.separatorStyle = .none
    }
    
    func setupFriendsTitle() {
        let title = "Friends"
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        friendsTitleLabel.attributedText = attributedText
    }
}
