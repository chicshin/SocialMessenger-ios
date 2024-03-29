//
//  UserApi.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/4/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class UserApi {
    func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }else{
                onSuccess()
            }
        })
    }
    
    func createUsername(withUsername username: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.displayName = username
//        changeRequest?.commitChanges(completion: nil)
        
        Ref().databaseUsers.child(ACTIVEUSERNAMES).child(username).observeSingleEvent(of: .value, with: { (usernameSnap) in
            if usernameSnap.exists() {
                let errorMessage = "username exists"
                onError(errorMessage)
                return
            }else{
                onSuccess()
            }
        })
    }
    
    func signUp(fullname: String, email: String, password: String, username: String, profileImageUrl: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: nil)
    
            
            if let authData = result {
                InstanceID.instanceID().instanceID { (ref, error) in
                
                    let dict : Dictionary<String,Any> = [
                        UID : authData.user.uid,
                        FULLNAME: fullname,
                        EMAIL : email,
                        USERNAME : username,
                        PROFILE_IMAGE_URL: profileImageUrl,
                        PUSHTOKEN : ref!.token,
                        NOTIFICATIONS : [SHOWPREVIEW: ENABLED, NEWFOLLOWERS: ENABLED],
                        STATUS: "",
                        FULLHD : ENABLED,
                        FLAGS : [SPAM: 0, FRAUD: 0, INAPPROPRIATE: 0, OTHER: 0]
                    ]
                
                    let ActiveUsernameDict : Dictionary<String,Any> = [
                        username : true,
                    ]
                    Ref().databaseUsers.child(authData.user.uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
                        if error == nil {
//                            Ref().databaseUsers.child("activeUsernames").updateChildValues(ActiveUsernameDict)
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    })
                    Ref().databaseUsers.child(ACTIVEUSERNAMES).updateChildValues(ActiveUsernameDict)
//                    Ref().databaseRoot.child(ACTIVEUSERNAMES).updateChildValues(ActiveUsernameDict)
                }
            }
        
        }
    }
    
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
            
        }
    }

    func ProfileImage(image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        let uid = Auth.auth().currentUser?.uid
        let imageSelected = image
        
        guard let imageData = imageSelected?.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        let dict : Dictionary<String,Any> = [
            PROFILE_IMAGE_URL: ""]
        
        let storageProfile = Ref().storageSpecificProfile(uid: uid!)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        StorageService.saveProfilePhoto(uid: uid!, data: imageData, metadata: metadata, storageProfile: storageProfile, dict: dict, onSuccess: {
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
            }
    }
    
    func status(text: String?) {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseSpecificUser(uid: uid!).updateChildValues(["status": text!])
    }
    
    func updateUsername(text: String?) {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseSpecificUser(uid: uid!).updateChildValues(["username": text!])
    }
    
    func updateFullname(text: String?) {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseSpecificUser(uid: uid!).updateChildValues(["fullname": text!])
    }
    
//    func ChatLogImageData(image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
//        let uid = Auth.auth().currentUser?.uid
//        let imageSelected = image
//        
//        guard let imageData = imageSelected?.jpegData(compressionQuality: 0.2) else {
//            return
//        }
//        
////        let dict: Dictionary<String,Any> = [
////            "imageUrl": ""
////        ]
//        let imageName = NSUUID().uuidString
//        let storageRef = Ref().storageRef.child("message_images").child(imageName)
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        
//        
//    }
}
