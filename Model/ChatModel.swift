//
//  ChatModel.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/9/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation

class ChatModel: NSObject{
    @objc var senderUid: String?
    @objc var text: String?
    @objc var toUid: String?
    @objc var timestamp: NSNumber?
}
