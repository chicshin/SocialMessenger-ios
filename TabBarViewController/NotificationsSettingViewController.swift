//
//  NotificationsSettingViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/24/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseAuth

class NotificationsSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView! = UITableView()
    
    var contents = ["Allow Notifications", "Show Preview", "New Followers"]
    var allowNotificationIsOn = false
    var showPreviewIsOn = false
    var newFollwersIsOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(notificationsCell.self, forCellReuseIdentifier: "notificationsCell")
        view.addSubview(tableView)
        
        checkNotifications()
        setupUI()
        
    }
    
    func setupUI() {
        setupTableView()
        setupNavigationBar()
//        checkPushToken()
    }
    
    func checkNotifications() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .authorized {
//                self.AllowNotificationIsOn = true
                print("authroized----")
            } else if settings.authorizationStatus == .denied {
                self.allowNotificationIsOn = false
                print("denied----")
            } else if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as! notificationsCell
        let content = contents[indexPath.row]
        
        cell.textLabel?.text = content
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        cell.switchButton.tag = indexPath.row
        
        switch indexPath.row {
        case 0:
            handleAllowNotification(cell: cell)
        case 1:
            handleShowPreview(cell: cell)
        case 2:
            handleNewFollwers(cell: cell)
        default:
            break
        }
        return cell
    }
    
    func handleAllowNotification(cell: notificationsCell) {
        cell.switchButton.isOn = allowNotificationIsOn
        if allowNotificationIsOn {
//            showPreviewIsOn = true
//            newFollwersIsOn = true
        } else {
            showPreviewIsOn = false
            newFollwersIsOn = false
        }
        cell.switchButton.addTarget(self, action: #selector(switchValueDidChange(_:)), for: UIControl.Event.valueChanged)
    }
    
    func handleShowPreview(cell: notificationsCell) {
        cell.switchButton.isOn = showPreviewIsOn
        if allowNotificationIsOn {
            cell.switchButton.isUserInteractionEnabled = true
        } else {
            cell.switchButton.isUserInteractionEnabled = false
        }
        cell.switchButton.addTarget(self, action: #selector(switchValueDidChange(_:)), for: UIControl.Event.valueChanged)
    }
    
    func handleNewFollwers(cell: notificationsCell) {
        cell.switchButton.isOn = newFollwersIsOn
        if allowNotificationIsOn {
            cell.switchButton.isUserInteractionEnabled = true
        } else {
            cell.switchButton.isUserInteractionEnabled = false
        }
        cell.switchButton.addTarget(self, action: #selector(switchValueDidChange(_:)), for: UIControl.Event.valueChanged)
    }
    
//    func handleSwitch(cell: notificationsCell) {
////        cell.switchButton.isOn = true
////        cell.switchButton.setOn(true, animated: false)
//        cell.switchButton.addTarget(self, action: #selector(switchValueDidChange(_:)), for: UIControl.Event.valueChanged)
//    }

    @objc func switchValueDidChange(_ sender: UISwitch) {
        let tag = sender.tag
        switch tag {
        case 0:
            if allowNotificationIsOn {
                removePushToken()
                showPreviewIsOn = false
                newFollwersIsOn = false
                allowNotificationIsOn = false
                let showPreview = ["notifications/showPreview": DISABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(showPreview)
                let newFollowers = ["notifications/newFollowers": DISABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(newFollowers)
            } else {
                createPushToken()
//                showPreviewIsOn = true
//                newFollwersIsOn = true
                allowNotificationIsOn = true
            }
            tableView.reloadData()
        case 1:
            if showPreviewIsOn {
                let showPreview = ["notifications/showPreview": DISABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(showPreview)
//                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(["showPreview": "disabled"])
                showPreviewIsOn = false
            } else {
                let showPreview = ["notifications/showPreview": ENABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(showPreview)
//                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(["showPreview": "enabled"])
                showPreviewIsOn = true
            }
        case 2:
            if newFollwersIsOn {
                let newFollowerNotification = ["notifications/newFollowers": DISABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(newFollowerNotification)
                //                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(["showPreview": "disabled"])
                newFollwersIsOn = false
            } else {
                let newFollowerNotification = ["notifications/newFollowers": ENABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(newFollowerNotification)
                //                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(["showPreview": "enabled"])
                newFollwersIsOn = true
            }
        default:
            break
        }
    }
}

class notificationsCell: UITableViewCell {
    var switchButton: UISwitch = {
        let button = UISwitch()
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(switchButton)
        
        switchButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
