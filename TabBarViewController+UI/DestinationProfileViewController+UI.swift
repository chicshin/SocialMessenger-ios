//
//  DestinationProfileViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Kingfisher
import Alamofire
import AlamofireImage

extension DestinationProfileViewController {
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
    
    
    
    
    func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 15
        tableView.clipsToBounds = true
        
        reportTableView.isScrollEnabled = false
        reportTableView.separatorStyle = .none
        reportTableView.layer.cornerRadius = 15
        reportTableView.clipsToBounds = true
    }
    
    func setupStatus() {
        var uid: String?
        if isSearching! {
            uid = self.allUser!.uid!
        } else if !isSearching! {
            uid = self.user!.uid!
        }
        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
            if let dict = dataSnapShot.value as? [String:Any] {
                guard let status = dict["status"] as? String else {
                    self.statusLabel.text = ""
                    return
                }
                self.statusLabel.text = status
            }
        })
    }
    
    func setupDestinationName() {
        if isSearching! {
            nameLabel.text = self.allUser!.username!
        } else if !isSearching! {
            nameLabel.text = self.user!.username!
        }
    }
    
    func setupProfileImage() {
        if isSearching! {
            let url = URL(string: self.allUser!.profileImageUrl!)
            profileImage.kf.setImage(with: url)
        } else if !isSearching! {
            let url = URL(string: self.user!.profileImageUrl!)
            profileImage.kf.setImage(with: url)
        }
    }
    
    func showBlockAlert() {
        let alert = UIAlertController(title: "Block " + nameLabel.text! + "?", message: "Tiki Talka won't notify them that you've blocked them.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancel blocking")
            self.transparentView.removeFromSuperview()
        }))
        alert.addAction(UIAlertAction(title: "Block", style: .default, handler: { (action: UIAlertAction!) in
            print("Blocked")
            self.transparentView.alpha = 0
            var blockUid: String?
            if self.isSearching! {
                blockUid = self.allUser!.uid!
            } else if !self.isSearching! {
                blockUid = self.user!.uid!
            }
            let uid = Auth.auth().currentUser?.uid
            Block().blockUser(uid: uid!, blockUid: blockUid!)
            self.menuContents.remove(at: 2)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showUnblockAlert() {
        let alert = UIAlertController(title: "Unblock " + nameLabel.text! + "?", message: "They will now be able to send you messages. Tiki Talka won't notify them that you've unblocked them.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.transparentView.removeFromSuperview()
        }))
        alert.addAction(UIAlertAction(title: "Unblock", style: .default, handler: { (action: UIAlertAction!) in
            self.transparentView.alpha = 0
            var unblockUid: String?
            if self.isSearching! {
                unblockUid = self.allUser!.uid!
            } else if !self.isSearching! {
                unblockUid = self.user!.uid!
            }
            let uid = Auth.auth().currentUser?.uid
            Block().unblockUser(uid: uid!, unblockUid: unblockUid!)
            self.menuContents.append("Follow")
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showUnfollowAlert() {
        let alert = UIAlertController(title: "Unfollow " + nameLabel.text! + "?", message: "Are you sure you want to unfollow " + nameLabel.text! + "? Tiki Talka won't notify the user that you've unfollowed " + nameLabel.text!, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.transparentView.removeFromSuperview()
        }))
        alert.addAction(UIAlertAction(title: "Unfollow", style: .default, handler: { (action: UIAlertAction!) in
            self.transparentView.alpha = 0
            var unfollowUid: String?
            if self.isSearching! {
                unfollowUid = self.allUser!.uid!
            } else if !self.isSearching! {
                unfollowUid = self.user!.uid!
            }
            UserRelationship().unfollow(unfollowUid: unfollowUid!)
        }))
        present(alert, animated: true, completion: nil)
    }
}
