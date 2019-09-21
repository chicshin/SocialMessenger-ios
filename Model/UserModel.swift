//
//  UserModel.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation

class UserModel: NSObject{

    @objc var email: String?
    @objc var fullname: String?
    @objc var profileImageUrl: String?
    @objc var uid: String?
    @objc var username: String?
    @objc var pushToken: String?
    @objc var notifications: [String:Any]?
    @objc var following: [String:Any]?
    @objc var followers: [String:Any]?
    @objc var status: String?
    @objc var fullHD: String?
    @objc var flags: [String:NSNumber]?
}
