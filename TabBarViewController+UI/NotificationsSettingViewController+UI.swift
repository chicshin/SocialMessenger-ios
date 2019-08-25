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
