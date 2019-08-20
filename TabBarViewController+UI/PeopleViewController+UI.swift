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
                            
                            self.filteredUser = self.Users
                        }
                        DispatchQueue.main.async {
                            self.friendsTableView.reloadData();
                        }
                    })
                }
            }
        })
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
    
//    func setupSearchButton() {
//        searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(showSearchInputTextField))
//        searchButton.tintColor = .lightGray
//        navigationItem.rightBarButtonItem = searchButton
//    }
    
    
//    func showCancleSearchButton() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleCancelSearchButton))
//        navigationItem.rightBarButtonItem?.tintColor = .black
//        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], for:UIControl.State.normal)
//
//    }
//
//    @objc func handleCancelSearchButton() {
//        setSearchBar()
//        searchBar.text = nil
//        isSearching = false
//        navigationItem.rightBarButtonItem = nil
//        friendsTitleLabel.isHidden = false
//        friendsTableView.reloadData()
//    }
    
    func setSearchBar() {
        searchBar.returnKeyType = UIReturnKeyType.search
        navigationItem.rightBarButtonItem = nil
        let frame = CGRect(x: 0, y: 0, width: 250, height: 44)
        let titleView = UIView(frame: frame)
        searchBar.frame = frame
        searchBar.placeholder = "Search"
        searchBar.isTranslucent = true
        
        setupSearchBarTextField()
        
        let offset = UIOffset(horizontal: (searchBar.frame.width - placeholderWidth) / 2 + 50, vertical: 0)
        searchBar.setPositionAdjustment(offset, for: .search)
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView

    }
    
    func setupSearchBarTextField() {
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.layer.cornerRadius = 20
        searchTextField?.clipsToBounds = true
        searchTextField?.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1).withAlphaComponent(0.5)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUser = Users.filter({ user -> Bool in
            if searchText.isEmpty {
                isSearching = false
                return true
            }
            return (user.username?.contains(searchText))!
        })
        friendsTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let noOffset = UIOffset(horizontal: 8, vertical: 0)
        searchBar.setPositionAdjustment(noOffset, for: .search)
        isSearching = true
        friendsTitleLabel.isHidden = true
        return true
    }
    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        print("didend ^^^^")
////        searchBar.setPositionAdjustment(offset, for: .search)
//        isSearching = false
//        return true
//    }
    
    
}

