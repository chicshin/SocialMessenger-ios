//
//  DatabaseService.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/12/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class DatabaseService {
//    static func updateDatabaseWithText(toUid: String, uid: String, values: Dictionary<String,Any>) {
//        let childRef = Ref().databaseRoot.child("messages").childByAutoId()
//        childRef.updateChildValues(values)
//
//        let messageId = childRef.key!
//        let userMessageRef = Ref().databaseRoot.child("user-messages").child(uid).child(toUid)
//        userMessageRef.updateChildValues([messageId: 1])
//
//        let recipientUserMessageRef = Ref().databaseRoot.child("user-messages").child(toUid).child(uid)
//        recipientUserMessageRef.updateChildValues([messageId: 1])
//    }
//
//    static func updateDatabaseWithImage(toUid: String, uid: String, values: Dictionary<String,Any>) {
//        let childRef = Ref().databaseRoot.child("messages").childByAutoId()
//        childRef.updateChildValues(values)
//
//        let messageId = childRef.key!
//        let userMessageRef = Ref().databaseRoot.child("user-messages").child(uid).child(toUid)
//        userMessageRef.updateChildValues([messageId: 1])
//
//        let recipientUserMessageRef = Ref().databaseRoot.child("user-messages").child(toUid).child(uid)
//        recipientUserMessageRef.updateChildValues([messageId: 1])
//    }
    
    static func updateMessagesWithValues(toUid: String, uid: String, values: Dictionary<String,Any>) {
        let childRef = Ref().databaseRoot.child("messages").childByAutoId()
        childRef.updateChildValues(values)
        
        let messageId = childRef.key!
        let userMessageRef = Ref().databaseRoot.child("user-messages").child(uid).child(toUid)
        userMessageRef.updateChildValues([messageId: 1])
        
        let recipientUserMessageRef = Ref().databaseRoot.child("user-messages").child(toUid).child(uid)
        recipientUserMessageRef.updateChildValues([messageId: 1])
    }
}
