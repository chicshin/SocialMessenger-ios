//
//  NotificationsSettingViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/24/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

extension NotificationsSettingViewController {
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
        tableView.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Notifications"
    }
    
    func removePushToken() {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseSpecificUser(uid: uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String:Any]
            for keys in dictionary.keys {
                if keys == "pushToken" {
                    Ref().databaseSpecificUser(uid: uid!).child(keys).removeValue()
                }
            }
        })
    }
    
    func createPushToken() {
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            }else if let result = result{
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(["pushToken": result.token])
            }
        }
    }
}
