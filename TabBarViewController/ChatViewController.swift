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
    
    var username = ""
    var imageUrlReceived = ""
    var user = [UserModel]()
    var destination = [CurrentUserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        inputTextField.delegate = self
        tableView.register(MyMessageCell.self, forCellReuseIdentifier: "MyMessageCell")

        view.addSubview(containerView)
        containerView.addSubview(inputTextField)
        containerView.addSubview(additionalButton)
        containerView.addSubview(sendButton)
        
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
        let uid = Auth.auth().currentUser?.uid
        let values : Dictionary<String,Any> = [
            "text": inputTextField.text!,
            "senderUid": uid!
            ]
        Ref().databaseRoot.child("messages").childByAutoId().updateChildValues(values)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
        
        let profileImage = cell.profileImage!
        let url = URL(string: imageUrlReceived)
        profileImage.layer.cornerRadius = 35/2
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.kf.setImage(with: url)
        return cell
    }

}

class MyMessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    let profileImage: UIImageView! = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(profileImage!)
        
        backgroundColor = .clear
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
//        messageLabel.text = "Some message here--ckgroundColor = .whitebubbleBackgroundView.layer.cornerRadius = 12bubbleBackgroundView.layer.borderWidth =  bubbleBackgroundView.layer.bor"
        messageLabel.numberOfLines = 0
        
        bubbleBackgroundView.backgroundColor = .white
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.layer.borderWidth = 1
        bubbleBackgroundView.layer.borderColor = #colorLiteral(red: 0.6617934108, green: 0, blue: 0.05319330841, alpha: 1)
        
    
        let constraints = [messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68),
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
        
        bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -15),
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
        bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -15),
        bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 15),
        
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        profileImage.widthAnchor.constraint(equalToConstant: 35),
        profileImage.heightAnchor.constraint(equalToConstant: 35)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DestinationMessageCell: UITableViewCell {
    
}
