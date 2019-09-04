//
//  NotificationModel.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/19/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import ObjectMapper

class NotificationModel: Mappable {
    public var to :String?
    public var notification :Notification = Notification()
    public var data :Data = Data()
//    public var senderId :String?
    
    init(){
        
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        to <- map["to"]
        notification <- map["notification"]
        data <- map["data"]
    }
    class Notification :Mappable{
        public var title: String?
        public var text: String?
        
        init() {
        }
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            title <- map["title"]
            text <- map["text"]
//            senderId <- map["senderId"]
        }
    }
    
    class Data :Mappable{
        public var title :String?
        public var text :String?
        
        init(){
        }
        
        required init?(map: Map) {
        }
        
        func mapping(map: Map) {
            title <- map["title"]
            text <- map["text"]
//            senderId <- map["senderId"]
        }
    }
}
