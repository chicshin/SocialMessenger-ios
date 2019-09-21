//
//  Block.swift
//  Tikitalka
//
//  Created by Jane Shin on 9/16/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Block {
    
    func blockUser(uid: String, blockUid: String) {
        Ref().databaseRoot.child(BLOCK).child(uid).child(BLOCKING).updateChildValues([blockUid:true])
        Ref().databaseRoot.child(BLOCK).child(blockUid).child(BLOCKEDBY).updateChildValues([uid:true])
        
        Ref().databaseSpecificUser(uid: uid).child(FOLLOWING).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            guard let blockedUser = snapshot.value as? String else {
                return
            }
            
            if blockedUser == blockUid {
                let key = snapshot.key
                Ref().databaseSpecificUser(uid: uid).child(FOLLOWING).child(key).removeValue()
                Ref().databaseSpecificUser(uid: blockUid).child(FOLLOWERS).child(key).removeValue()
            }
        })
        
    }
    
    func unblockUser(uid: String, unblockUid: String) {
        Ref().databaseRoot.child(BLOCK).child(uid).child(BLOCKING).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                return
            }
            for key in dict.keys {
                if key == unblockUid {
                    Ref().databaseRoot.child(BLOCK).child(uid).child(BLOCKING).child(unblockUid).removeValue()
                }
            }
        })
        
        Ref().databaseRoot.child(BLOCK).child(unblockUid).child(BLOCKEDBY).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                return
            }
            for key in dict.keys {
                if key == uid {
                    Ref().databaseRoot.child(BLOCK).child(unblockUid).child(BLOCKEDBY).child(uid).removeValue()
                }
            }
        })
    }
    
    func observeBlockedUser(blockedUid: String, completion: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseRoot.child(BLOCK).child(uid!).child(BLOCKING).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                completion(false)
                return
            }
            for key in dict.keys {
                if key == blockedUid {
                    completion(true)
                    return
                }
            }
            completion(false)
        })
    }
    
    func observeFlaggedUser(completion: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseRoot.child(FLAGGEDUSERS).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                completion(false)
                return
            }
            for key in dict.keys {
                if key == uid {
                    completion(true)
                    return
                }
            }
            completion(false)
        })
    }
    
    func updateFlag(flagUser: String, reason: String, flaggedEmail: String) {
        Ref().databaseSpecificUser(uid: flagUser).child(FLAGS).child(reason).observeSingleEvent(of: .value, with: { (snapshot) in
            guard var flagNumbers = snapshot.value as? Int else {
                return
            }
            flagNumbers += 1
            let flags = [reason: flagNumbers]
            Ref().databaseSpecificUser(uid: flagUser).child(FLAGS).updateChildValues(flags)
        })
        shouldBlockFlaggedUser(flagUser: flagUser, flaggedEmail: flaggedEmail)
    }
    
    func shouldBlockFlaggedUser(flagUser: String, flaggedEmail: String) {
        var flagsCount = 0
        Ref().databaseSpecificUser(uid: flagUser).child(FLAGS).observe(.childAdded, with: { (snapshot) in
            guard let flagNumbers = snapshot.value as? Int else {
                return
            }
            flagsCount += flagNumbers
            if flagsCount >= 2 {
                let flagged = ["flaggedUsers/\(flagUser)": flaggedEmail]
                Ref().databaseRoot.updateChildValues(flagged)
                
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).child(FOLLOWING).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    guard let flaggedUser = snapshot.value as? String else {
                        return
                    }
                    
                    if flaggedUser == flagUser {
                        let key = snapshot.key
                        Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).child(FOLLOWING).child(key).removeValue()
                        Ref().databaseSpecificUser(uid: flagUser).child(FOLLOWERS).child(key).removeValue()
                    }
                })
                return
            }
        })
    }
    
    

}
