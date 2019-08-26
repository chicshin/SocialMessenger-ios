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
    
    let array = ["Account", "Notifications", "Sign Out"]
    var token = ""
    var showPreview = ""
    var newFollowers = ""
    
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
        self.token = ""
        checkTokenAndShowPreview()
    }

    func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        let list = array[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        setupCell(cell: cell, list: list)
        cell.textLabel?.text = list
        return cell
    }
    
    func setupCell(cell: SettingsCell, list: String) {
        if list == "Sign Out" {
            cell.nextImageView.isHidden = true
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1)
        } else {
            if list == "Account" {
                cell.nextImageView.isHidden = false
                cell.imageView?.image = #imageLiteral(resourceName: "person")
            }
            if list == "Notifications" {
                cell.nextImageView.isHidden = false
                cell.imageView?.image = #imageLiteral(resourceName: "notification")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "showProfileAccountSegue", sender: self)
        case 1:
            self.performSegue(withIdentifier: "notificationSettingSegue", sender: self)
        case 2:
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nextImageView)
        
        nextImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nextImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        nextImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
