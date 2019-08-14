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
    
    func timestampString() -> String? {
        var timeString: String?
        if let seconds = timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            print(timestampDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            timeString = dateFormatter.string(from: timestampDate as Date)
        }
        return timeString
    }
    
    func datestampString() -> String? {
        var dateString: String?
        if let seconds = timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateString = dateFormatter.string(from: timestampDate as Date)
        }
        return dateString
    }
    func today() -> String? {
        var today: String?
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let timestampDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        today = dateFormatter.string(from: timestampDate as Date)
        return today
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
