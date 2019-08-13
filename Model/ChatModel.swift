//
//  ChatModel.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/9/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
import Firebase

class ChatModel: NSObject{
    @objc var senderUid: String?
    @objc var text: String?
    @objc var toUid: String?
    @objc var timestamp: NSNumber?
    
    @objc var imageUrl: String?
    @objc var imageWidth: NSNumber?
    @objc var imageHeight: NSNumber?
    @objc var videoUrl: String?
    
    func chatPartnerUid() -> String? {
        return senderUid == Auth.auth().currentUser?.uid ? toUid : senderUid
    }
    
    init(dictionary: [String: Any]) {
        super.init()
        senderUid = dictionary["senderUid"] as? String
        text = dictionary["text"] as? String
        toUid = dictionary["toUid"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
    }
}
