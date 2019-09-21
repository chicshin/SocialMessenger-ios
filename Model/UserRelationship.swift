//
//  UserRelationship.swift
//  Tikitalka
//
//  Created by Jane Shin on 9/17/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
import FirebaseAuth
import Alamofire

class UserRelationship {
    func unfollow(unfollowUid: String) {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseSpecificUser(uid: uid!).child("following").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            for key in dictionary.keys {
                if dictionary[key] as? String == unfollowUid {
                    Ref().databaseSpecificUser(uid: uid!).child("following").child(key).removeValue()
                    Ref().databaseSpecificUser(uid: unfollowUid).child("followers").child(key).removeValue()
                }
            }
        })
    }
    
    func follow(followUid: String, pushToken: String, isFCMOn: Bool) {
        let uid = Auth.auth().currentUser?.uid
        let key = Ref().databaseUsers.childByAutoId().key
        let following = ["following/\(key!)": followUid]
        Ref().databaseSpecificUser(uid: uid!).updateChildValues(following)
        let followers = ["followers/\(key!)": uid!]
        Ref().databaseSpecificUser(uid: followUid).updateChildValues(followers)
        
        if isFCMOn {
            sendFcm(pushToken: pushToken)
        }
    }
    
    func sendFcm(pushToken: String) {
        let url = "https://fcm.googleapis.com/fcm/send"
        let header: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "key=AIzaSyDA3sKFVIMUl_t5ADdEkKOW-iCo26DIgjw"
            //            "Authorization": "key=SECURE API KEY"
        ]
        
        let name = Auth.auth().currentUser?.displayName
        
        let notificationModel = NotificationModel()
        notificationModel.notification.text = "\(String(describing: name!)) started following you"
        notificationModel.data.text = "\(String(describing: name!)) started following you"
        
        let params = notificationModel.toJSON()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            print(response.result.value as Any)
        }
    }
    
    func observeUnfollowedUser(unfollowedUid: String, completion: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser?.uid
        Ref().databaseSpecificUser(uid: uid!).child(FOLLOWING).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else {
                completion(false)
                return
            }
            for key in dictionary.keys {
                if dictionary[key] as? String == unfollowedUid {
                    completion(true)
                    return
                }
            }
            completion(false)
        })
    }
}
