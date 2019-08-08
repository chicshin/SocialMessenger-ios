//
//  CurrentUserModel.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation

class CurrentUserModel {
    var usernameText: String
    var profileImageUrl: String
    var uidString: String
    
    init(username: String, profileImageUrlString: String, uid: String) {
        usernameText = username
        profileImageUrl = profileImageUrlString
        uidString = uid
    }
}
