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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var friendsTitleLabel: UILabel!
    
    let searchBar: UISearchBar = UISearchBar()
    let placeholderWidth: CGFloat = 200
    var isSearching = false
    
    var Users = [UserModel]()
    var AllUsers = [AllUserModel]()
    var CurrentUser = [CurrentUserModel]()
    var filteredUser = [AllUserModel]()

    var currentIndexPathRow: Int?
    
    var friendsCount = 0
    var addUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        friendsTableView.dataSource = self
        tableView.delegate = self
        friendsTableView.delegate = self
        searchBar.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        print("-8-")
        setupTableView()
        loadMyProfile()
        loadSearch()
        setupFriendsCountTitle()
        setupImage()
        setSearchBar()
        setupNavigationBar()
        loadFriends()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("-7-")
        setSearchBar()
        setupImage()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tap.cancelsTouchesInView = false
//        self.view.endEditing(true)
//    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if Auth.auth().currentUser != nil{
//            self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
//        }
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.tableView {
            count = CurrentUser.count
        }
        
        if tableView == self.friendsTableView {
            if !isSearching {
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
            let user = CurrentUser[indexPath.row]
            
            let url = URL(string: user.profileImageUrl!)
            cell.profileImage.kf.setImage(with: url)
            cell.profileImage.contentMode = .scaleAspectFill
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
            cell.profileImage.clipsToBounds = true
            cell.usernameLabel.text = user.username!
            
            cellToReturn = cell
            
        }
        if tableView == self.friendsTableView {
            let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
            if !isSearching {
                let user = Users[indexPath.row]
                
                setupCell(cell: cell, user: user)
                cell.followButton.isHidden = true

                
                cellToReturn = cell
                
            } else if isSearching {
                let user = filteredUser[indexPath.row]
                
                cell.followButton.tag = indexPath.row
                setupCellForSearch(cell: cell, user: user)
                setupFollowButton(cell: cell)
                didTapFollow(cell: cell, user: user)
                
                if user.followers != nil {
                    for (_, value) in user.followers! {
                        if value as? String == Auth.auth().currentUser?.uid {
                            cell.followButton.isHidden = true
                        }
                    }                    
                }
                cellToReturn = cell
            }
        } 
        return cellToReturn
    }
    
    func setupCell(cell: FriendsCell, user: UserModel) {
        let url = URL(string: user.profileImageUrl!)
        cell.profileImage.kf.setImage(with: url)
        cell.usernameLabel.text = user.username!
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.contentMode = .scaleAspectFill
        cell.profileImage.clipsToBounds = true
    }
    
    func setupCellForSearch(cell: FriendsCell, user: AllUserModel) {
        let url = URL(string: user.profileImageUrl!)
        cell.profileImage.kf.setImage(with: url)
        cell.usernameLabel.text = user.username!
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
        cell.profileImage.contentMode = .scaleAspectFill
        cell.profileImage.clipsToBounds = true
    }
    
    func didTapFollow(cell: FriendsCell, user: AllUserModel) {
        cell.followButton.isUserInteractionEnabled = true
        cell.followButton.addTarget(self, action: #selector(handleFollow(sender:)), for: .touchUpInside)
    }
    
    @objc func handleFollow(sender:UIButton) {
        let tag = sender.tag
        let uid = Auth.auth().currentUser?.uid
        let followUid = filteredUser[tag].uid
        let key = Ref().databaseUsers.childByAutoId().key
        
//        Ref().databaseSpecificUser(uid: uid!).child("following").observeSingleEvent(of: .value, with: { (snapshot) in
//            let following = ["following/\(followUid!)": 1]
//            Ref().databaseSpecificUser(uid: uid!).updateChildValues(following)
//        })
        let following = ["following/\(key!)": followUid!]
        Ref().databaseSpecificUser(uid: uid!).updateChildValues(following)
        let followers = ["followers/\(key!)": uid!]
        Ref().databaseSpecificUser(uid: followUid!).updateChildValues(followers)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            let view = storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! ProfileViewController
            navigationController?.present(view, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }else{
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
    
//    @IBAction func didTapFollow(_ sender: Any) {
//        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
//        cell.followButton.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFollow))
//        cell.followButton.addGestureRecognizer(tapGesture)
//    }
}



class MyCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
}

class FriendsCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
}

