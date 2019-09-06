//
//  PeopleViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import AlamofireImage
import Kingfisher

class PeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var tableView: UITableView! = UITableView()
    var friendsTableView: UITableView! = UITableView()
    
    let searchBar: UISearchBar = UISearchBar()
    let placeholderWidth: CGFloat = 200
    var isSearching = false
    
    var Users = [UserModel]()
    var AllUsers = [AllUserModel]()
    var CurrentUser = [CurrentUserModel]()
    var filteredUser = [AllUserModel]()
    var userDictionary = [String: UserModel]()
    var currentIndexPathRow: Int?
    
    var friendsCount = 0
    var addUid: String?
    
    var friendsTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        do {
//            try Auth.auth().signOut()
//        } catch let logutError {
//            print(logutError)
//        }
        
        tableView.dataSource = self
        friendsTableView.dataSource = self
        tableView.delegate = self
        friendsTableView.delegate = self
        tableView.register(MyCell.self, forCellReuseIdentifier: "MyCell")
        friendsTableView.register(FriendsCell.self, forCellReuseIdentifier: "FriendsCell")
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = navigationController?.navigationBar.frame.size.height
        let tabHeight = tabBarController?.tabBar.frame.size.height
        let width = UIScreen.main.bounds.width
        
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            tableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 10, width: width, height: 80)
            friendsTableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 100, width: width, height: UIScreen.main.bounds.height - tabHeight! - (statusBarHeight + navHeight! + 90))
            friendsTitleLabel.frame = CGRect(x: 20, y: statusBarHeight + navHeight! + 78, width: 80, height: 20)
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            tableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 10, width: width, height: 75)
            friendsTableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 95, width: width, height: UIScreen.main.bounds.height - tabHeight! - (statusBarHeight + navHeight! + 85))
            friendsTitleLabel.frame = CGRect(x: 20, y: statusBarHeight + navHeight! + 79, width: 80, height: 20)
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            tableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 10, width: width, height: 75)
            friendsTableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 95, width: width, height: UIScreen.main.bounds.height - tabHeight! - (statusBarHeight + navHeight! + 85))
            friendsTitleLabel.frame = CGRect(x: 15, y: statusBarHeight + navHeight! + 79, width: 80, height: 20)
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            tableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 10, width: width, height: 70)
            friendsTableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 90, width: width, height: UIScreen.main.bounds.height - tabHeight! - (statusBarHeight + navHeight! + 80))
            friendsTitleLabel.frame = CGRect(x: 20, y: statusBarHeight + navHeight! + 73, width: 80, height: 20)
        } else {
            tableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight!, width: width, height: 70)
            friendsTableView.frame = CGRect(x: 0, y: statusBarHeight + navHeight! + 80, width: width, height: UIScreen.main.bounds.height - tabHeight! - (statusBarHeight + navHeight! + 80))
            friendsTitleLabel.frame = CGRect(x: 15, y: statusBarHeight + navHeight! + 63, width: 80, height: 20)
        }
        
        view.addSubview(tableView)
        view.addSubview(friendsTableView)
        view.addSubview(friendsTitleLabel)

        searchBar.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        loadFriends()
        setupTableView()
        loadMyProfile()
        loadSearch()
        setupFriendsCountTitle()
//        setupImage()
        setSearchBar()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchBar()
//        setupImage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
                return 80
            }
            else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
                return 75
                
            } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
                return 75
                
            } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
                return 70
                
            } else {
                return 70
            }
        } else if tableView == self.friendsTableView {
            
            if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
                return 62
            }
            else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
                return 57
                
            } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
                return 57
                
            } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
                return 52
                
            } else {
                return 43
            }
        }
        return 80
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.tableView {
            count = CurrentUser.count
        }
        
        if tableView == self.friendsTableView {
            if !isSearching {
                friendsCount = Users.count
                setupFriendsCountTitle()
                count =  Users.count
            } else {
                count = filteredUser.count
            }
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
            cell.selectionStyle = .none
            let user = CurrentUser[indexPath.row]
            
            let url = URL(string: user.profileImageUrl!)
            cell.profileImage.kf.setImage(with: url)
            cell.profileImage.contentMode = .scaleAspectFill
            cell.usernameLabel.text = user.username!
//            cell.usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
//            KBIZforSMEsgo L
            
            cellToReturn = cell
            
        }
        if tableView == self.friendsTableView {
            let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
            if !isSearching {
                let user = Users[indexPath.row]
                setupCell(cell: cell, user: user)
                cell.followImageView.isHidden = true
                cell.followButton.isHidden = true
                friendsTitleLabel.isHidden = false
                cell.unfollowButton.isHidden = true
                setupFriendsCountTitle()
//
                cellToReturn = cell
            } else if isSearching {
                let user = filteredUser[indexPath.row]

                friendsTitleLabel.isHidden = true
                setupCellForSearch(cell: cell, user: user)
                cell.followImageView.isHidden = false
                cell.followButton.isHidden = false
                cell.unfollowButton.isHidden = true

                Ref().databaseSpecificUser(uid: user.uid!).child("followers").observe(.childAdded, with: { (snapshot) in
                    guard let followers = snapshot.value as? String else {

                        return
                    }
                    if followers == Auth.auth().currentUser?.uid {
                        cell.unfollowButton.isHidden = false
                        cell.followButton.isHidden = true
                        cell.followImageView.isHidden = true
                    }
                })

                cell.followButton.tag = indexPath.row
                cell.unfollowButton.tag = indexPath.row

                didTapFollow(cell: cell)
                didTapUnfollow(cell: cell)

                cellToReturn = cell
            }
        }
        return cellToReturn
    }
    
    func setupCell(cell: FriendsCell, user: UserModel) {
        let url = URL(string: user.profileImageUrl!)
        cell.profileImage.kf.setImage(with: url)
        cell.usernameLabel.text = user.username!
//        cell.usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
//        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.contentMode = .scaleAspectFill
//        cell.profileImage.clipsToBounds = true
    }

    func setupCellForSearch(cell: FriendsCell, user: AllUserModel) {
        let url = URL(string: user.profileImageUrl!)
        cell.profileImage.kf.setImage(with: url)
        cell.usernameLabel.text = user.username!
//        cell.usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
//        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.contentMode = .scaleAspectFill
        cell.profileImage.clipsToBounds = true
    }
    
    func didTapFollow(cell: FriendsCell) {
        cell.followButton.isUserInteractionEnabled = true
        cell.followButton.addTarget(self, action: #selector(handleFollow(sender:)), for: .touchUpInside)
    }
    
    func didTapUnfollow(cell: FriendsCell) {
        cell.unfollowButton.isUserInteractionEnabled = true
        cell.unfollowButton.addTarget(self, action: #selector(handleUnfollow(sender:)), for: .touchUpInside)
    }
    
    @objc func handleFollow(sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = friendsTableView.cellForRow(at: indexPath) as! FriendsCell
        let uid = Auth.auth().currentUser?.uid
        let followUid = filteredUser[tag].uid
        let key = Ref().databaseUsers.childByAutoId().key

        let following = ["following/\(key!)": followUid!]
        Ref().databaseSpecificUser(uid: uid!).updateChildValues(following)
        let followers = ["followers/\(key!)": uid!]
        Ref().databaseSpecificUser(uid: followUid!).updateChildValues(followers)

        if filteredUser[tag].notifications!["newFollowers"] as! String == "enabled" {
            sendFcm(tag: tag)
        }
        cell.followImageView.isHidden = true
        cell.followButton.isHidden = true
        cell.unfollowButton.isHidden = false

    }
    
    @objc func handleUnfollow(sender:UIButton) {
        let tag = sender.tag
        let uid = Auth.auth().currentUser?.uid
        let followUid = filteredUser[tag].uid

        Ref().databaseSpecificUser(uid: uid!).child("following").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            for key in dictionary.keys {
                if dictionary[key] as? String == followUid {
                    Ref().databaseSpecificUser(uid: uid!).child("following").child(key).removeValue()
                    Ref().databaseSpecificUser(uid: followUid!).child("followers").child(key).removeValue()
                    self.userDictionary.removeValue(forKey: followUid!)
                    self.attemptReloadTable()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView == self.tableView {
            let view = storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! ProfileViewController
            navigationController?.present(view, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
//            friendsTableView.deselectRow(at: indexPath, animated: true)
//            let view = storyboard?.instantiateViewController(withIdentifier: "DestinationProfileVC") as! DestinationProfileViewController
//            navigationController?.present(view, animated: true, completion: nil)
            currentIndexPathRow = indexPath.row
            performSegue(withIdentifier: "sendUserDataSegue", sender: self)
            friendsTableView.deselectRow(at: indexPath, animated: true)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendUserDataSegue" {
            let vc = segue.destination as! DestinationProfileViewController
            if !isSearching {
                vc.user = self.Users[currentIndexPathRow!]
                vc.isSearching = false
            } else if isSearching {
                vc.allUser = self.filteredUser[currentIndexPathRow!]
                vc.isSearching = true
            }
        }
    }
}



class MyCell: UITableViewCell {
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(usernameLabel)
        
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            profileImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
            profileImage.layer.cornerRadius = 60/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 55).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 55).isActive = true
            profileImage.layer.cornerRadius = 55/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)

        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 55).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 55).isActive = true
            profileImage.layer.cornerRadius = 55/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)

        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
            profileImage.layer.cornerRadius = 50/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)

        } else {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.layer.cornerRadius = 45/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FriendsCell: UITableViewCell {
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = #imageLiteral(resourceName: "addFriend").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
    let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return button
    }()
    
    let unfollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.setTitle("unfollow", for: UIControl.State.normal)
        button.tintColor = .lightGray
        button.titleLabel?.textAlignment = .right
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(followImageView)
        addSubview(followButton)
        addSubview(unfollowButton)
        
        if UIDevice.modelName == "iPhone XS Max" || UIDevice.modelName == "iPhone XR" {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            profileImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
            profileImage.layer.cornerRadius = 50/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            //            usernameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            followButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            followButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            followButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            
            followImageView.centerYAnchor.constraint(equalTo: followButton.centerYAnchor).isActive = true
            followImageView.centerXAnchor.constraint(equalTo: followButton.centerXAnchor).isActive = true
            followImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            followImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            
            unfollowButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
        }
        else if UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus" || UIDevice.modelName == "iPhone 8 Plus"{
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.layer.cornerRadius = 45/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            //            usernameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            followButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            followButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            followButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
            followButton.layer.cornerRadius = 13
            followButton.clipsToBounds = true
            
            followImageView.centerYAnchor.constraint(equalTo: followButton.centerYAnchor).isActive = true
            followImageView.centerXAnchor.constraint(equalTo: followButton.centerXAnchor).isActive = true
            followImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            followImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            unfollowButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 17)
            
        } else if UIDevice.modelName == "Simulator iPhone X" || UIDevice.modelName == "iPhone XS" {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
            profileImage.layer.cornerRadius = 45/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            //            usernameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            followButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            followButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            followButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
            followButton.layer.cornerRadius = 13
            followButton.clipsToBounds = true
            
            followImageView.centerYAnchor.constraint(equalTo: followButton.centerYAnchor).isActive = true
            followImageView.centerXAnchor.constraint(equalTo: followButton.centerXAnchor).isActive = true
            followImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            followImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            unfollowButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
        } else if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 7" || UIDevice.modelName == "iPhone 8"{
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
            profileImage.layer.cornerRadius = 40/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            //            usernameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            followButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            followButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
            followButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
            followButton.layer.cornerRadius = 13
            followButton.clipsToBounds = true
            
            followImageView.centerYAnchor.constraint(equalTo: followButton.centerYAnchor).isActive = true
            followImageView.centerXAnchor.constraint(equalTo: followButton.centerXAnchor).isActive = true
            followImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            followImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            unfollowButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            
        } else {
            profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
            profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
            profileImage.layer.cornerRadius = 35/2
            
            usernameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 25).isActive = true
            usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
            
            followButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
            followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            followButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
            followButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            followButton.layer.cornerRadius = 11
            followButton.clipsToBounds = true
            
            followImageView.centerYAnchor.constraint(equalTo: followButton.centerYAnchor).isActive = true
            followImageView.centerXAnchor.constraint(equalTo: followButton.centerXAnchor).isActive = true
            followImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
            followImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
            
            unfollowButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            usernameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        }
        unfollowButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        unfollowButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -17).isActive = true
        unfollowButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

