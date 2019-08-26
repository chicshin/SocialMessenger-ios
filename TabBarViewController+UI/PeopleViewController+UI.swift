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
import Alamofire

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
    }
    
    func loadFriends() {
        let uid = Auth.auth().currentUser?.uid
        if !isSearching {
            Ref().databaseSpecificUser(uid: uid!).child("following").observe(.childAdded, with: { (snapshot) in
//                self.Users.removeAll()
                let followingUid = snapshot.value
                let user = UserModel()
                Ref().databaseUsers.child(followingUid as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
//                        let user = UserModel()
                        user.setValuesForKeys(dictionary)
//                        self.Users.append(user)
                        self.userDictionary[followingUid as! String] = user
                        self.attemptReloadTable()
                        print("loadfriends childadded Users count: ", self.Users.count)
                    }
                })
            })
            Ref().databaseSpecificUser(uid: uid!).child("following").observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                print(snapshot.value!, " // will be removed")
                self.Users.removeAll()
                self.userDictionary.removeValue(forKey: snapshot.value as! String)
                print(self.userDictionary)
                self.attemptReloadTable()
            })
        }
        
    }
    
    func attemptReloadTable() {
        self.Users = Array(self.userDictionary.values)
        DispatchQueue.main.async {
            self.friendsTableView.reloadData();
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
            print("TexstDidChange")
            if searchText.isEmpty {
                print("isSearching is: ", isSearching, "in textdidchange")
                isSearching = false
                friendsTitleLabel.isHidden = false
                return true
            } else if !searchText.isEmpty {
                isSearching = true
                return (user.username?.lowercased().contains(searchText.lowercased()))!
            }
            return false
        })
        print("textDidchange will reload table")
        friendsTableView.reloadData()
        loadSearch()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("searchBarShouldBeginEdting")
        let noOffset = UIOffset(horizontal: 8, vertical: 0)
        searchBar.setPositionAdjustment(noOffset, for: .search)
        isSearching = false
        return true
    }

    func setupFollowButton(cell: FriendsCell) {
        cell.followButton.setTitle("", for: UIControl.State.normal)
        cell.followButton.setImage(#imageLiteral(resourceName: "addFriend"), for: UIControl.State.normal)
        cell.followButton.tintColor = .white

        cell.followButton.backgroundColor = #colorLiteral(red: 0.6620325446, green: 0.0003923571203, blue: 0.05706844479, alpha: 1).withAlphaComponent(0.9)
        cell.followButton.layer.cornerRadius = 13
        cell.followButton.clipsToBounds = true
    }
    
    func setupUnfollowButton(cell: FriendsCell) {
        cell.unfollowButton.setTitle("Unfollow", for: UIControl.State.normal)
        cell.unfollowButton.tintColor = .lightGray
    }
    
    func sendFcm(tag: Int) {
        let url = "https://fcm.googleapis.com/fcm/send"
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "key=AIzaSyDA3sKFVIMUl_t5ADdEkKOW-iCo26DIgjw"
            //            "Authorization": "key=SECURE API KEY"
        ]
        
        let name = Auth.auth().currentUser?.displayName
        
        let notificationModel = NotificationModel()
        if isSearching {
            notificationModel.to = filteredUser[tag].pushToken
        }
        //        notificationModel.notification.title = name
        notificationModel.notification.text = "\(String(describing: name!)) started following you"
        //        notificationModel.data.title = name
        notificationModel.data.text = "\(String(describing: name!)) started following you"
        
        let params = notificationModel.toJSON()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            print(response.result.value as Any)
        }
    }
}

