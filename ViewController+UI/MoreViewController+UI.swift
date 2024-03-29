//
//  MoreViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

extension MoreViewController {
    func removePushToken() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Ref().databaseSpecificUser(uid: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String:Any]
            for keys in dictionary.keys {
                if keys == "pushToken" {
                    Ref().databaseSpecificUser(uid: uid).child(keys).removeValue()
                }
            }
        })
    }
    
    
    
    func handleSignOut() {
        removePushToken()
        do {
            try Auth.auth().signOut()
        } catch let logutError {
            print(logutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    func showSignOutAlert() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancel sign out")
        }))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action: UIAlertAction!) in
            self.handleSignOut()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Settings"
    }
    
    func checkTokenAndShowPreview() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Ref().databaseSpecificUser(uid: uid).observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as! [String:Any]
    
            for keys in dictionary.keys {
                if keys == "pushToken" {
                    self.token = dictionary["pushToken"] as! String
                }
                if keys == "notifications" {
                    Ref().databaseSpecificUser(uid: uid).child("notifications").observeSingleEvent(of: .value, with: { (snapshot) in
                        let dict = snapshot.value as! [String:Any]
                        
                        if dict["showPreview"] as! String == "enabled" {
                            self.showPreview = "true"
                        } else {
                            self.showPreview = "false"
                        }
                        
                        if dict["newFollowers"] as! String == "enabled" {
                            self.newFollowers = "true"
                        } else {
                            self.newFollowers = "false"
                        }
                    })
                }
                if keys == FULLHD {
                    Ref().databaseSpecificUser(uid: uid).child(FULLHD).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dict = snapshot.value as? String else {
                            return
                        }
                        if dict == ENABLED {
                            self.fullHDIsOn = true
                        } else {
                            self.fullHDIsOn = false
                        }
                        let indexPath = IndexPath(row: 2, section: 0)
                        let cell = self.tableView.cellForRow(at: indexPath) as! SettingsCell
                        cell.switchButton.isOn = self.fullHDIsOn
                        
                    })
                }
                
            }
        })
    }
    
}
