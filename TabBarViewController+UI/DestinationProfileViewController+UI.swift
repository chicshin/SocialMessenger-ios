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
    func setupChatButton() {
        
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
            profileImage.layer.cornerRadius = profileImage.frame.width/2
            profileImage.clipsToBounds = true
            profileImage.contentMode = .scaleAspectFill
        } else if !isSearching! {
            let url = URL(string: self.user!.profileImageUrl!)
            profileImage.kf.setImage(with: url)
            profileImage.layer.cornerRadius = profileImage.frame.width/2
            profileImage.clipsToBounds = true
            profileImage.contentMode = .scaleAspectFill
        }
    }
    func setupCloseButton() {
        closeButton.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        closeButton.tintColor = .black
    }
}
