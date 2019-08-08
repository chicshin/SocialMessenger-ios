//
//  UserModel.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation

class UserModel{
    var usernameText: String
    var profileImageUrl: String
    var uidString: String

    init(username: String, profileImageUrlString: String, uid: String) {
        usernameText = username
        profileImageUrl = profileImageUrlString
        uidString = uid
    }

//    @objc var email: String?
//    @objc var fullname: String?
//    @objc var profileImageUrl: String?
//    @objc var uid: String?
//    @objc var username: String?
}
