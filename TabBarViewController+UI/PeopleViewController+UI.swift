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
        
        Ref().databaseUsers.child(uid!).observe(.value, with: { (snapshot) in
            self.CurrentUser.removeAll()
            if let dict = snapshot.value as? [String:Any] {
                let user = CurrentUserModel()
                user.setValuesForKeys(dict)
                self.CurrentUser.append(user)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isScrollEnabled = false
            }
        })
    }
    func loadPeople() {
        let myUid = Auth.auth().currentUser?.uid
        Ref().databaseUsers.observe(.value, with: { (snapshot) in
            self.Users.removeAll()
            let dict = snapshot.value as? [String:Any]
            for child in dict!.keys {
                if child != myUid && child != "activeUsernames" {
                    let uid = child
                    let user = UserModel()
                    Ref().databaseUsers.child(uid).observe(.value, with: { (data) in
                        if let dictionary = data.value as? [String:Any] {
                            user.setValuesForKeys(dictionary)
                            self.Users.append(user)
                        }
                        DispatchQueue.main.async {
                            self.friendsTableView.reloadData();
                        }
                    })
                }
            }
        })
    }
    
    func setupImage() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! MyCell
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.clipsToBounds = true
        
        let friendsCell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        friendsCell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        friendsCell.profileImage.clipsToBounds = true
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        friendsTableView.separatorStyle = .none
    }
    
    func setupFriendsCountTitle() {
        let title = "Friends "
        let subTitle = String(self.friendsCount)
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        attributedText.append(attributedSubText)
        
        friendsTitleLabel.attributedText = attributedText
    }
    
    func setupSearchButton() {
        let searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(showSearchInputTextField))
        searchButton.tintColor = .lightGray
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func showSearchInputTextField() {
        
    }
}
