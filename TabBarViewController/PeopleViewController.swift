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
    var CurrentUser = [CurrentUserModel]()
    var filteredUser = [UserModel]()

    var currentIndexPathRow: Int?
    
    var friendsCount = 0
    
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
        setupTableView()
        loadMyProfile()
        loadPeople()
        setupFriendsCountTitle()
        setupImage()
        setSearchBar()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSearchBar()
        setupImage()
    }
    
    
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
//            count =  Users.count
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
            if !isSearching {
                let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
                let user = Users[indexPath.row]
                
                let url = URL(string: user.profileImageUrl!)
                cell.profileImage.kf.setImage(with: url)
                cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
                cell.profileImage.contentMode = .scaleAspectFill
                cell.profileImage.clipsToBounds = true
                cell.usernameLabel.text = user.username!
                
                cellToReturn = cell
                
            } else if isSearching {
                let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
                let user = filteredUser[indexPath.row]
                
                let url = URL(string: user.profileImageUrl!)
                cell.profileImage.kf.setImage(with: url)
                cell.profileImage.layer.cornerRadius = cell.profileImage.frame.width/2
                cell.profileImage.contentMode = .scaleAspectFill
                cell.profileImage.clipsToBounds = true
                cell.usernameLabel.text = user.username!
                
                cellToReturn = cell
            }
            
        }

        return cellToReturn
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
            print("issearching---------", isSearching)
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
            } else if isSearching {
                vc.user = self.filteredUser[currentIndexPathRow!]
            }
        }
    }
}



class MyCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
}

class FriendsCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
}
