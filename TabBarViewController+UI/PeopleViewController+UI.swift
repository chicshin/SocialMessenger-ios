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
    
    func loadSearch() {
        let myUid = Auth.auth().currentUser?.uid
        Ref().databaseUsers.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            self.AllUsers.removeAll()
            let users = snapshot.value as! [String:AnyObject]
            for (key, value) in users {
                let uid = value.value(forKey: "uid") as? String
                if key != "activeUsernames" && uid != myUid {
                    let dictionary = value as? [String:Any]
                    let user = AllUserModel()
                    user.setValuesForKeys(dictionary!)
                    self.AllUsers.append(user)
                }
                
            }
        })
//        Ref().databaseUsers.observe(.value, with: { (snapshot) in
//            self.AllUsers.removeAll()
//            let dict = snapshot.value as? [String:Any]
//            for child in dict!.keys {
//                let user = AllUserModel()
//                if child != myUid && child != "activeUsernames" {
//                    let uid = child
////                    let user = AllUserModel()
//                    Ref().databaseUsers.child(uid).observe(.value, with: { (data) in
//                        if let dictionary = data.value as? [String:Any] {
//                            user.setValuesForKeys(dictionary)
//                            self.AllUsers.append(user)
//                        }
//                    })
//                }
//            }
//        })
    }
    
    func loadFriends() {
        let uid = Auth.auth().currentUser?.uid
        if !isSearching {
            Ref().databaseSpecificUser(uid: uid!).child("following").observe(.childAdded, with: { (snapshot) in
//                self.Users.removeAll()
                let followingUid = snapshot.value
                let user = UserModel()
                Ref().databaseUsers.child(followingUid as! String).observe(.value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
                        user.setValuesForKeys(dictionary)
                        self.Users.append(user)
                    }
                    DispatchQueue.main.async {
                        self.friendsTableView.reloadData();
                    }
                })
            })
        }
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        friendsTableView.separatorStyle = .none
    }
    
    func setupImage() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! MyCell
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.clipsToBounds = true
        
        let friendsCell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        friendsCell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        friendsCell.profileImage.clipsToBounds = true
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
    
    func setSearchBar() {
        let frame = CGRect(x: 0, y: 0, width: 250, height: 44)
        let titleView = UIView(frame: frame)
        searchBar.frame = frame
        setupSearchBarUI()
        
        let offset = UIOffset(horizontal: (searchBar.frame.width - placeholderWidth) / 2 + 50, vertical: 0)
        searchBar.setPositionAdjustment(offset, for: .search)
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView

    }
    
    func setupSearchBarUI() {
        
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.placeholder = "Search"
        searchBar.isTranslucent = true
        
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.layer.cornerRadius = 20
        searchTextField?.clipsToBounds = true
        searchTextField?.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1).withAlphaComponent(0.5)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUser = AllUsers.filter({ user -> Bool in
            if searchText.isEmpty {
                isSearching = false
                friendsTitleLabel.isHidden = false
                return true
            } else if !searchText.isEmpty {
                isSearching = true
                return (user.username?.lowercased().contains(searchText.lowercased()))!
            }
            return false
        })
        friendsTableView.reloadData()
        loadSearch()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let noOffset = UIOffset(horizontal: 8, vertical: 0)
        searchBar.setPositionAdjustment(noOffset, for: .search)
        isSearching = false
        return true
    }
    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        print("didend ^^^^")
////        searchBar.setPositionAdjustment(offset, for: .search)
//        isSearching = false
//        return true
//    }
    func setupFollowButton(cell: FriendsCell) {
//        cell.followButton.isHidden = false
        cell.followButton.setTitle(" Add", for: UIControl.State.normal)
        cell.followButton.setImage(#imageLiteral(resourceName: "addFriend"), for: UIControl.State.normal)
        cell.followButton.tintColor = .white
        //        cell.followButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 4, bottom: 6, right:3)
        cell.followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.followButton.backgroundColor = #colorLiteral(red: 0.6620325446, green: 0.0003923571203, blue: 0.05706844479, alpha: 1).withAlphaComponent(0.9)
        cell.followButton.layer.cornerRadius = 15
        cell.followButton.clipsToBounds = true
        cell.followButton.setTitleColor(.white, for: UIControl.State.normal)
    }
}

