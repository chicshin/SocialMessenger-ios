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
import Alamofire
import AlamofireImage

extension DestinationProfileViewController {
    func setupChatButton() {}
    
    func setupDestinationeInfo() {
//        let myUid = Auth.auth().currentUser?.uid
//        Ref().databaseUsers.observe(.value, with: { (snapshot: DataSnapshot) in
//            self.users.removeAll()
//            let dict = snapshot.value as? [String:Any]
//            var uids = ""
//            for child in dict!.keys {
//                if child != myUid && child != "activeUsernames"{
//                    uids = child
//                    Ref().databaseUsers.child(uids).observe(.value, with: { (data: DataSnapshot) in
//                        if let dictTemp = data.value as? [String:Any] {
//                            let username = dictTemp["username"] as! String
//                            let profileImageUrlString = dictTemp["profileImageUrl"] as! String
//                            let uid = dictTemp["uid"] as! String
//                            let user = UserModel(username: username, profileImageUrlString: profileImageUrlString, uid: uid)
//                            self.users.append(user)                        }
//                    })
//                }
//            }
//        })
    }
    func setupDestinationName() {
        nameLabel.text = usernameReceived
    }
    func setupProfileImage() {
        Alamofire.request(imageReceived).responseImage {
            (response) in
            if let image = response.result.value {
                self.profileImage.image = image
            }
        }
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }
    func setupCloseButton() {
        closeButton.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
        closeButton.tintColor = .black
    }
}
