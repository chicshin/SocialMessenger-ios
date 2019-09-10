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
                let followingUid = snapshot.value
                let user = UserModel()
                Ref().databaseUsers.child(followingUid as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String:Any] {
                        user.setValuesForKeys(dictionary)
                        self.userDictionary[followingUid as! String] = user
                        self.friendsCount = self.userDictionary.count
                        self.attemptReloadTable()
                    }
                })
            })
            Ref().databaseSpecificUser(uid: uid!).child("following").observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                self.Users.removeAll()
                self.userDictionary.removeValue(forKey: snapshot.value as! String)
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
    }
    
    func setupFriendsCountTitle() {
        let title = "Friends "
        let subTitle = String(self.friendsCount)
        
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            styleFriends(title: title, subTitle: subTitle, fontSize: 12)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            styleFriends(title: title, subTitle: subTitle, fontSize: 12)
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            styleFriends(title: title, subTitle: subTitle, fontSize: 12)
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            styleFriends(title: title, subTitle: subTitle, fontSize: 11)
        } else {
            styleFriends(title: title, subTitle: subTitle, fontSize: 11)
        }
    }
    
    func styleFriends(title: String, subTitle: String, fontSize: Int) {
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Medium", size: CGFloat(fontSize))!,
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes:
            [NSAttributedString.Key.font : UIFont(name: "AppleSDGothicNeo-Medium", size: CGFloat(fontSize))!,
             NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        attributedText.append(attributedSubText)
        
        friendsTitleLabel.attributedText = attributedText
    }
    
    func setSearchBar() {
        var titleView = UIView()
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            let frame = CGRect(x: 0, y: 0, width: 250, height: 44)
            titleView = UIView(frame: frame)
            searchBar.frame = frame
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            let frame = CGRect(x: 0, y: 0, width: 250, height: 38)
            titleView = UIView(frame: frame)
            searchBar.frame = frame
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            let frame = CGRect(x: 0, y: 0, width: 220, height: 40)
            titleView = UIView(frame: frame)
            searchBar.frame = frame
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            let frame = CGRect(x: 0, y: 0, width: 200, height: 35)
            titleView = UIView(frame: frame)
            searchBar.frame = frame
        } else {
            let frame = CGRect(x: 0, y: 0, width: 180, height: 32)
            titleView = UIView(frame: frame)
            searchBar.frame = frame
        }
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
        let sortedArr = AllUsers.sorted(by: {(lhs: AllUserModel, rhs: AllUserModel) in
            let lhsValue = lhs.username
            let rhsValue = rhs.username
            return lhsValue! < rhsValue!
        })
        filteredUser = sortedArr.filter({ user -> Bool in
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
        loadSearch()
        friendsTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let noOffset = UIOffset(horizontal: 8, vertical: 0)
        searchBar.setPositionAdjustment(noOffset, for: .search)
        isSearching = false
        return true
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
        notificationModel.notification.text = "\(String(describing: name!)) started following you"
        notificationModel.data.text = "\(String(describing: name!)) started following you"
        
        let params = notificationModel.toJSON()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            print(response.result.value as Any)
        }
    }
}

