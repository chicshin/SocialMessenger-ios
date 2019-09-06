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
}
