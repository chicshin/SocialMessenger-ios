//
//  timestampModel.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/11/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation

extension listCell {
    
    func timestamp(chat: ChatModel) {
        if let seconds = chat.timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            timestampLabel.text = dateFormatter.string(from: timestampDate as Date)
        }
    }
}

extension chatMessageCell {
    func timestamp(chat: ChatModel) {
        if let seconds = chat.timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
//            timestamp.text = dateFormatter.string(from: timestampDate as Date)
        }
    }
}

