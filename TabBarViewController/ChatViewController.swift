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
//    let containerView: UIView! = UIView()
//    let additionalButton: UIButton! = UIButton()
//    let sendButton: UIButton! = UIButton(type: .system)
    
    var userModel: UserModel?
//    var user = [UserModel]()
    var destination = [CurrentUserModel]()
    var Chat = [ChatModel]()
    var messagesDictionary = [String: ChatModel]()
    var containerViewBottomAnchor: NSLayoutConstraint?
    var containerViewHeightAnchor: NSLayoutConstraint?
    var inputTextFieldBottomAnchor: NSLayoutConstraint?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        inputTextField.delegate = self
        tableView.register(MyMessageCell.self, forCellReuseIdentifier: "MyMessageCell")
        tableView.register(DestinationMessageCell.self, forCellReuseIdentifier: "DestinationMessageCell")
        tableView.keyboardDismissMode = .interactive
        
        showMessageLogs()
//        setupKeyboardObserver()
        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        setupNavigationBar()
    }
    
    lazy var inputContainerVeiw: UIView = {
        let containerView = UIView()
//        let inputTextField = UITextField()
        let additionalButton = UIButton()
        let sendButton = UIButton(type: .system)
        
        containerView.addSubview(inputTextField)
        containerView.addSubview(additionalButton)
        containerView.addSubview(sendButton)
        
        additionalButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 0.9)
        
        inputTextField.placeholder = "Enter text here..."
        inputTextField.frame = CGRect(x: 40, y: 5, width: 310, height: 35)
        
        additionalButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        additionalButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        additionalButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        additionalButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
        
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor).isActive = true
        
        inputTextField.backgroundColor = .white
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.lightGray.cgColor
        inputTextField.layer.cornerRadius = 18
        inputTextField.clipsToBounds = true
        
        let leftView = UILabel(frame: CGRect(x: 10, y: 0, width: 14, height: 30))
        let rightView = UILabel(frame: CGRect(x: -10, y: 0, width: 5, height: 30))
        inputTextField.leftView = leftView
        inputTextField.leftViewMode = .always
        inputTextField.rightView = rightView
        inputTextField.rightViewMode = .always
        additionalButton.setImage(#imageLiteral(resourceName: "add_circle").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
        additionalButton.tintColor = UIColor.lightGray
        
        sendButton.setTitle("Send", for: UIControl.State.normal)
        sendButton.setTitleColor(#colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1), for: UIControl.State.normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        sendButton.addTarget(self, action: #selector(handleSend), for: UIControl.Event.touchUpInside)
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            
            return inputContainerVeiw
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    //prevent memory leak
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    @objc func dismissChat() {
        self.view.endEditing(true)
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
        
        inputTextField.text = ""
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
