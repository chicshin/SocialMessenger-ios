//
//  StorageService.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD

class StorageService {
//    static func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfile: StorageReference, dict: Dictionary<String,Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
//        storageProfile.putData(data, metadata: metadata, completion: {
//            (storageMetadata, error) in
//            if error != nil {
//                onError(error!.localizedDescription)
//                return
//            }
//            
//            storageProfile.downloadURL(completion: { (url, error) in
//                if let metaImageUrl = url?.absoluteString {
//                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
//                        changeRequest.photoURL = url
//                        changeRequest.displayName = username
//                        changeRequest.commitChanges(completion: { (error) in
//                            if let error = error {
//                                ProgressHUD.showError(error.localizedDescription)
//                            }
//                        })
//                    }
//                    
//                    var dictTemp = dict
//                    dictTemp[PROFILE_IMAGE_URL] = metaImageUrl
//                    
//                    Ref().databaseSpecificUser(uid: uid).updateChildValues(dictTemp, withCompletionBlock: { (error, ref) in
//                        if error == nil {
//                            onSuccess()
//                        } else{
//                            onError(error!.localizedDescription)
//                        }
//                    })
//                }
//            })
//        })
//    }
    
    static func saveProfilePhoto(uid: String, data: Data, metadata: StorageMetadata, storageProfile: StorageReference, dict: Dictionary<String,Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        storageProfile.putData(data, metadata: metadata, completion: {
            (storageMetadata, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            storageProfile.downloadURL(completion: { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.commitChanges(completion: { (error) in
                            if let error = error {
                                ProgressHUD.showError(error.localizedDescription)
                            }
                        })
                    }
                    
                    var dictTemp = dict
                    dictTemp[PROFILE_IMAGE_URL] = metaImageUrl
                    
                    Ref().databaseSpecificUser(uid: uid).updateChildValues(dictTemp, withCompletionBlock: { (error, ref) in
                        if error == nil {
                            onSuccess()
                        } else{
                            onError(error!.localizedDescription)
                        }
                    })
                }
            })
        })
    }
}
