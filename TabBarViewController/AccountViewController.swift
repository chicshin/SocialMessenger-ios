//
//  AccountViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/23/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView! = UITableView()

    var CurrentUser = [CurrentUserModel]()
    var contents = ["ProfileImageUrl", "Name", "Username", "Email", "Status"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        
        view.addSubview(tableView)
        
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return 180
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let content = contents[indexPath.row]
        cell.textLabel?.text = content
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        
        Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                switch indexPath.row {
                case 0:
                    cell.textLabel?.isHidden = true
                    cell.bottomLine.isHidden = true
                    let url = URL(string: dictionary["profileImageUrl"] as! String)
                    cell.profileImageView.kf.setImage(with: url)
                    cell.profileImageView.contentMode = .scaleAspectFill
                    cell.profileImageView.layer.cornerRadius = 100 / 2
                    cell.profileImageView.clipsToBounds = true
                case 1:
                    cell.contentLabel.text = dictionary["fullname"] as? String
                    cell.seperateLine.isHidden = true
                case 2:
                    cell.contentLabel.text = dictionary["username"] as? String
                    cell.seperateLine.isHidden = true
                case 3:
                    cell.contentLabel.text = dictionary["email"] as? String
                    cell.contentLabel.textColor = .lightGray
                    cell.seperateLine.isHidden = true
                case 4:
                    cell.contentLabel.text = "hello this is status"
                    cell.seperateLine.isHidden = true
                default:
                    break
                }
            }
        })
        return cell
    }

}

class ProfileCell: UITableViewCell {
    var contentLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 15)
        return text
    }()
    
    var profileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var bottomLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1)
        return line
    }()
    
    var seperateLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1)
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(contentLabel)
        addSubview(bottomLine)
        addSubview(profileImageView)
        addSubview(seperateLine)
        
        contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        contentLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        contentLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        bottomLine.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        bottomLine.widthAnchor.constraint(equalToConstant: 250).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        seperateLine.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40).isActive = true
        seperateLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        seperateLine.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
