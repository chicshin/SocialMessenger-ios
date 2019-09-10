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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }
    
    func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    func checkNotifications() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .authorized {
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
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            return 45
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            return 43
            
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            return 42
            
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            return 38
            
        } else {
            return 38
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsCell", for: indexPath) as! notificationsCell
        let content = contents[indexPath.row]
        
        cell.textLabel?.text = content
        
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
                allowNotificationIsOn = true
            }
            tableView.reloadData()
        case 1:
            if showPreviewIsOn {
                let showPreview = ["notifications/showPreview": DISABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(showPreview)
                showPreviewIsOn = false
            } else {
                let showPreview = ["notifications/showPreview": ENABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(showPreview)
                showPreviewIsOn = true
            }
        case 2:
            if newFollwersIsOn {
                let newFollowerNotification = ["notifications/newFollowers": DISABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(newFollowerNotification)
                newFollwersIsOn = false
            } else {
                let newFollowerNotification = ["notifications/newFollowers": ENABLED]
                Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(newFollowerNotification)
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
        
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        } else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            textLabel?.font = UIFont.systemFont(ofSize: 14)
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } else {
            textLabel?.font = UIFont.systemFont(ofSize: 13)
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        switchButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
