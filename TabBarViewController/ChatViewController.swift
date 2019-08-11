//
//  ChatViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/7/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import AlamofireImage
import Kingfisher

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    let inputTextField: UITextField! = UITextField()
    let containerView: UIView! = UIView()
    let additionalButton: UIButton! = UIButton()
    let sendButton: UIButton! = UIButton(type: .system)
    
    var userModel: UserModel?
//    var user = [UserModel]()
    var destination = [CurrentUserModel]()
    var Chat = [ChatModel]()
    var messagesDictionary = [String: ChatModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        inputTextField.delegate = self
        tableView.register(MyMessageCell.self, forCellReuseIdentifier: "MyMessageCell")
        tableView.register(DestinationMessageCell.self, forCellReuseIdentifier: "DestinationMessageCell")

        view.addSubview(containerView)
        containerView.addSubview(inputTextField)
        containerView.addSubview(additionalButton)
        containerView.addSubview(sendButton)
        
        showMessageLogs()
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupNavigationBar()
        setupTextField()
        setupBottomViewConstraints()
        setupAdditionalButton()
        setupSendButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            tableView.translatesAutoresizingMaskIntoConstraints = false
            containerView.translatesAutoresizingMaskIntoConstraints = false
//            messageTextField.translatesAutoresizingMaskIntoConstraints = false
            self.containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardSize.height).isActive = true
//            self.messageTextField.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: keyboardSize.height).isActive = true
//            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keyboardSize.height).isActive = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        let margins = view.layoutMarginsGuide
//        self.containerView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    @objc func dismissChat() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSend() {
        let childRef = Ref().databaseRoot.child("messages").childByAutoId()
        let uid = Auth.auth().currentUser?.uid
        let toUid = userModel!.uid
        let timestamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values : Dictionary<String,Any> = [
            "text": inputTextField.text!,
            "senderUid": uid!,
            "toUid": toUid!,
            "timestamp": timestamp
            ]
        childRef.updateChildValues(values)
        
        let messageId = childRef.key! 
        let userMessageRef = Ref().databaseRoot.child("user-messages").child(uid!)
        userMessageRef.updateChildValues([messageId: 1])
        
        let recipientUserMessageRef = Ref().databaseRoot.child("user-messages").child(toUid!)
        recipientUserMessageRef.updateChildValues([messageId: 1])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        if (self.Chat[indexPath.row].toUid == Auth.auth().currentUser?.uid) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationMessageCell", for: indexPath) as! DestinationMessageCell
            let chat = Chat[indexPath.row]
            cell.messageLabel.text = chat.text
            cell.timestamp(chat: chat)
            
            let profileImage = cell.profileImage!
            let url = URL(string: userModel!.profileImageUrl!)
            profileImage.layer.cornerRadius = 35/2
            profileImage.contentMode = .scaleAspectFill
            profileImage.clipsToBounds = true
            profileImage.kf.setImage(with: url)
            
            cellToReturn = cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            let chat = Chat[indexPath.row]
            cell.messageLabel.text = chat.text
            cell.timestamp(chat: chat)
            
            cellToReturn = cell
        }
        return cellToReturn
    }
}

class MyMessageCell: UITableViewCell {
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    let timestamp = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(timestamp)
        
        constraints()
        
        backgroundColor = .clear
        
        messageLabel.numberOfLines = 0
        bubbleBackgroundView.backgroundColor = #colorLiteral(red: 0.9411043525, green: 0.9412171841, blue: 0.9410660267, alpha: 1).withAlphaComponent(0.9)
        bubbleBackgroundView.layer.cornerRadius = 18
        timestamp.font = UIFont.systemFont(ofSize: 12)
        timestamp.textColor = .lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DestinationMessageCell: UITableViewCell {
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    let profileImage: UIImageView! = UIImageView()
    let timestamp = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(profileImage!)
        addSubview(timestamp)
        
        constraints()
        
        backgroundColor = .clear
        
        messageLabel.numberOfLines = 0
        bubbleBackgroundView.backgroundColor = .white
        bubbleBackgroundView.layer.cornerRadius = 18
        bubbleBackgroundView.layer.borderWidth = 1
        bubbleBackgroundView.layer.borderColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1)
        timestamp.font = UIFont.systemFont(ofSize: 12)
        timestamp.textColor = .lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
