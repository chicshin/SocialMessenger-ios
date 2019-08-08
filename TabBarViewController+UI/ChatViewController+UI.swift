//
//  ChatViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/7/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

extension ChatViewController {
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 1, alpha: 1)
    }
    
    func setupNavigationBar() {
//        let screenSize: CGRect = UIScreen.main.bounds
//        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 40))
//        let navigationItem = UINavigationItem(title: "Name")
        navigationItem.title = self.username
        let dismissButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissChat))
        navigationItem.leftBarButtonItem = dismissButton

    }
    
    func setupTextField() {
        let title = "Enter text..."
        
        let attributedText = NSMutableAttributedString(string: title, attributes:
            [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor : UIColor.lightGray.withAlphaComponent(0.9)])
        
        inputTextField.attributedPlaceholder = attributedText
        
        inputTextField.backgroundColor = .white
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.lightGray.cgColor
        inputTextField.layer.cornerRadius = 10
        inputTextField.clipsToBounds = true
        
        let leftView = UILabel(frame: CGRect(x: 10, y: 0, width: 8, height: 30))
        let rightView = UILabel(frame: CGRect(x: -10, y: 0, width: 5, height: 30))
        inputTextField.leftView = leftView
        inputTextField.leftViewMode = .always
        inputTextField.rightView = rightView
        inputTextField.rightViewMode = .always
    }
    
    func setupBottomViewConstraints() {
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 0.9)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        additionalButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            inputTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -60),
            inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            inputTextField.heightAnchor.constraint(equalToConstant: 30),
            
            additionalButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            additionalButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            additionalButton.widthAnchor.constraint(equalToConstant: 30),
            additionalButton.heightAnchor.constraint(equalToConstant: 30),
            
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupAdditionalButton() {
        additionalButton.setImage(#imageLiteral(resourceName: "add_circle").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
        additionalButton.tintColor = UIColor.lightGray
    }

    func setupSendButton() {
        sendButton.setTitle("Send", for: UIControl.State.normal)
        sendButton.setTitleColor(#colorLiteral(red: 0, green: 0.4799541235, blue: 0.9984330535, alpha: 1), for: UIControl.State.normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        sendButton.addTarget(self, action: #selector(handleSend), for: UIControl.Event.touchUpInside)
    }
}
