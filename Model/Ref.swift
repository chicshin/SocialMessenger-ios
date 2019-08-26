//
//  Ref.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/4/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
import Firebase

let REF_USER = "users"
let STORAGE_PROFILE = "profile"
let PROFILE_IMAGE_URL = "profileImageUrl"
let UID = "uid"
let EMAIL = "email"
let FULLNAME = "fullname"
let USERNAME = "username"
let ERROR_EMPTY_PHOTO = "Please choose your profile image"
let ERROR_EMPTY_EMAIL = "Please enter an email address"
let ERROR_EMPTY_USERNAME = "Please enter an username"
let ERROR_EMPTY_PASSWORD = "Please enter a password"
let ERROR_EMPTY_EMAIL_RESET = "please enter an email address for password reset"
let SUCCESS_EMAIL_RESET = "We have just sent you a password email reset. Please check your inbox and follow the instructions to reset your password."
let PUSHTOKEN = "pushToken"
let NOTIFICATIONS = "notifications"
let STATUS = "status"
let SHOWPREVIEW = "showPreview"
let NEWFOLLOWERS = "newFollowers"
let ENABLED = "enabled"
let DISABLED = "disabled"
let ACTIVEUSERNAMES = "activeUsernames"

class Ref {
    let databaseRoot : DatabaseReference = Database.database().reference()
    
    var databaseUsers : DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    let storageRef : StorageReference = Storage.storage().reference()
    
    var storageProfile : StorageReference {
        return storageRef.child(STORAGE_PROFILE)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
