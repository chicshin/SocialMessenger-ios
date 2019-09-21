//
//  MoreViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView! = UITableView()
    
    let array = ["Account", "Notifications", "Full HD", "Blocking", "Sign Out"]
    var token = ""
    var showPreview = ""
    var newFollowers = ""
    var fullHDIsOn = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        
        view.addSubview(tableView)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.portrait)
        self.token = ""
        checkTokenAndShowPreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }

    func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            return 40
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            return 40
            
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            return 37
            
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            return 33
            
        } else {
            return 32
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        let list = array[indexPath.row]
        setupCell(cell: cell, list: list)
        cell.switchButton.tag = indexPath.row
        handleFullHD(cell: cell)
        cell.textLabel?.text = list
        return cell
    }
    
    func setupCell(cell: SettingsCell, list: String) {
        if list == "Sign Out" {
            cell.nextImageView.isHidden = true
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1)
            cell.switchButton.isHidden = true
        } else {
            if list == "Account" {
                cell.nextImageView.isHidden = false
                cell.switchButton.isHidden = true
                cell.imageView?.image = #imageLiteral(resourceName: "person")
            }
            if list == "Notifications" {
                cell.nextImageView.isHidden = false
                cell.switchButton.isHidden = true
                cell.imageView?.image = #imageLiteral(resourceName: "notification")
            }
            if list ==  "Full HD" {
                cell.nextImageView.isHidden = true
                cell.switchButton.isHidden = false
                cell.imageView?.image = #imageLiteral(resourceName: "hd")
            }
            if list == "Blocking" {
                cell.nextImageView.isHidden = false
                cell.switchButton.isHidden = true
                cell.imageView?.image = #imageLiteral(resourceName: "block")
            }
        }
    }
    
    func handleFullHD(cell: SettingsCell) {
        cell.switchButton.isOn = fullHDIsOn
        cell.switchButton.addTarget(self, action: #selector(switchValueDidChange(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if fullHDIsOn {
        fullHDIsOn = false
        let fullHDStatus = ["fullHD": DISABLED]
        Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(fullHDStatus)
        } else {
        fullHDIsOn = true
        let fullHDStatus = ["fullHD": ENABLED]
        Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues(fullHDStatus)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "showProfileAccountSegue", sender: self)
        case 1:
            self.performSegue(withIdentifier: "notificationSettingSegue", sender: self)
        case 3:
            self.performSegue(withIdentifier: "showBlockingSegue", sender: self)
        case 4:
            showSignOutAlert()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notificationSettingSegue" {
            let vc = segue.destination as! NotificationsSettingViewController
            if token != "" {
                vc.allowNotificationIsOn = true
            }
            if showPreview == "true" {
                vc.showPreviewIsOn = true
            } else if showPreview == "false" {
                vc.showPreviewIsOn = false
            }
            
            if newFollowers == "true" {
                vc.newFollwersIsOn = true
            } else if newFollowers == "false" {
                vc.newFollwersIsOn = false
            }
        }
        
//        if segue.identifier == "ResolutionSegue" {
//            let vc = segue.destination as! ResolutionViewController
//            if dataImageIsOn == "true" {
//                vc.dataImageIsOn = true
//            } else if dataImageIsOn == "false" {
//                vc.dataImageIsOn = false
//            }
//            
//            if dataVideoIsOn == "true" {
//                vc.dataVideoIsOn = true
//            } else if dataVideoIsOn == "false" {
//                vc.dataVideoIsOn = false
//            }
//            
//            if wifiImageIsOn == "true" {
//                vc.wifiImageIsOn = true
//            } else if wifiImageIsOn == "false" {
//                vc.wifiImageIsOn = false
//            }
//            
//            if wifiVideoIsOn == "true" {
//                vc.wifiVideoIsOn = true
//            } else if wifiVideoIsOn == "false" {
//                vc.wifiVideoIsOn = false
//            }
//        }
    }
}

class SettingsCell: UITableViewCell {
    var nextImageView: UIImageView = {
        let next = UIImageView()
        next.translatesAutoresizingMaskIntoConstraints = false
        next.image = #imageLiteral(resourceName: "right_arrow")
        next.image = next.image?.withRenderingMode(.alwaysTemplate)
        next.tintColor = .lightGray
        return next
    }()
    
    var switchButton: UISwitch = {
        let button = UISwitch()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nextImageView)
        addSubview(switchButton)
        
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            nextImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            nextImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            nextImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
            nextImageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
            
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            nextImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            nextImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            nextImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
            nextImageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
            
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            textLabel?.font = UIFont.systemFont(ofSize: 14)
            nextImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            nextImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            nextImageView.heightAnchor.constraint(equalToConstant: 26).isActive = true
            nextImageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
            
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            textLabel?.font = UIFont.systemFont(ofSize: 14)
            nextImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            nextImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            nextImageView.heightAnchor.constraint(equalToConstant: 26).isActive = true
            nextImageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
            
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } else {
            textLabel?.font = UIFont.systemFont(ofSize: 12)
            nextImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            nextImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            nextImageView.heightAnchor.constraint(equalToConstant: 26).isActive = true
            nextImageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
            
            switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            switchButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        switchButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
