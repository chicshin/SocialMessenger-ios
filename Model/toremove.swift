//
//  toremove.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/12/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation
//class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {


//        observeMessageLog()
//        setupKeyboardObserver()
//        setupUI()
//    }
//    
//    func setupUI() {
//        setupTableView()
//        setupNavigationBar()
//    }


//    //prevent memory leak
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }






//----------------------------
//                if let returnValue = chat.text != nil ? chat.text : chat.videoUrl != nil ? chat.videoUrl : chat.imageUrl {
//
//                    makeArray.append(ChatViewController.dateModelStructure(date: chat.datestampString()!, content: returnValue, timestamp: chat.timestamp!))
//                }
//                self.messagesPerDateDictionary = makeArray
//
//                var dd = self.dateSection
//                if self.messagesPerDateDictionary.count == 12 {
//                    self.result = self.messagesPerDateDictionary
//
//                    let dates = Set(self.result.map({return $0.date}))
//                    var array = [dateModelStructure]()
//                    for date in dates {
//                        array = self.result.filter({$0.date == date})
//                        dd.append(array)
//                    }
////                    self.dateSection = dd
////                    let group = Dictionary(grouping: self.result, by:  { $0.date })
//                }
//                self.dateSection = dd

//                                var mpdd = self.messagesPerDateDictionary
//                mpdd.append(chat.datestampString()!)
//                self.messagesPerDateDictionary = mpdd
//                print(self.messagesPerDateDictionary)
