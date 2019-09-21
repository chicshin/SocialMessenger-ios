//
//  BlockingViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 9/16/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension BlockingViewController {
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
    
    
    func observeBlockedUsers() {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseRoot.child(BLOCK).child(uid!).child(BLOCKING).observe(.childAdded, with: { (snapshot) in
            guard let _ = snapshot.value else {
                return
            }
            let blockedUid = snapshot.key
            let user = AllUserModel()
            Ref().databaseUsers.child(blockedUid).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    user.setValuesForKeys(dictionary)
                    self.userDictionary[blockedUid] = user
                    self.attemptReloadTable()
                }
            })
            
        })
    }
    
    func attemptReloadTable() {
        self.AllUsers = Array(self.userDictionary.values)
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
}

