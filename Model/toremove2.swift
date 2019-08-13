//
//  toremove2.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/12/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation


//
//extension MyMessageCell {
//    func constraints() {
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        timestamp.translatesAutoresizingMaskIntoConstraints = false
//        messageImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        let constraints = [messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
//                           messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
//                           messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//                           messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
//                           
//                           bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -13),
//                           bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 13),
//                           
//                           bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -13),
//                           bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 13),
//                           
//                           timestamp.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: 0),
//                           timestamp.trailingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: -5),
//                           
//                           messageImageView.leftAnchor.constraint(equalTo: bubbleBackgroundView.leftAnchor),
//                           messageImageView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor),
//                           messageImageView.widthAnchor.constraint(equalTo: bubbleBackgroundView.widthAnchor),
//                           messageImageView.heightAnchor.constraint(equalTo: bubbleBackgroundView.heightAnchor)
//        ]
//        
//        NSLayoutConstraint.activate(constraints)
//    }
//}
//
//extension DestinationMessageCell {
//    func constraints() {
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//        profileImage.translatesAutoresizingMaskIntoConstraints = false
//        timestamp.translatesAutoresizingMaskIntoConstraints = false
//        
//        let constraints = [messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 35),
//                           messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
//                           messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 68),
//                           messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
//                           
//                           bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -13),
//                           bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 13),
//                           bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -13),
//                           bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 13),
//                           
//                           profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
//                           profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//                           profileImage.widthAnchor.constraint(equalToConstant: 35),
//                           profileImage.heightAnchor.constraint(equalToConstant: 35),
//                           
//                           timestamp.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: 0),
//                           timestamp.leadingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: 5)
//        ]
//        
//        NSLayoutConstraint.activate(constraints)
//    }
//}
////    func setupKeyboardObserver() {
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
////    }
////
////    @objc func keyboardWillShow(notification: NSNotification) {
////        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
////        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval)
////        containerViewBottomAnchor?.constant = -keyboardFrame.height
////        containerViewHeightAnchor?.constant = 45
////        inputTextFieldBottomAnchor?.constant = -5
////
////        UIView.animate(withDuration: keyboardDuration, animations: {
////            self.view.layoutIfNeeded()
////        })
////    }
////
////    @objc func keyboardWillHide(notification: NSNotification) {
////        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval)
////        containerViewBottomAnchor?.constant = 0
////        containerViewHeightAnchor?.constant = 60
////        inputTextFieldBottomAnchor?.constant = -20
////
////        UIView.animate(withDuration: keyboardDuration, animations: {
////            self.view.layoutIfNeeded()
////        })
////    }
////    func setupContainerViewConstraints() {
////        containerView.backgroundColor = UIColor(white: 0.95, alpha: 0.9)
////
////        containerView.translatesAutoresizingMaskIntoConstraints = false
////        inputTextField.translatesAutoresizingMaskIntoConstraints = false
////        additionalButton.translatesAutoresizingMaskIntoConstraints = false
////        sendButton.translatesAutoresizingMaskIntoConstraints = false
////
////        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
////        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 60)
////        inputTextFieldBottomAnchor = inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
////        containerViewBottomAnchor?.isActive = true
////        containerViewHeightAnchor?.isActive = true
////        inputTextFieldBottomAnchor?.isActive = true
////
////        let constraints = [containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
////                           containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
////
////                           inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
////                           inputTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -60),
////                           inputTextField.heightAnchor.constraint(equalToConstant: 35),
////
////                           additionalButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
////                           additionalButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
////                           additionalButton.widthAnchor.constraint(equalToConstant: 30),
////                           additionalButton.heightAnchor.constraint(equalToConstant: 30),
////
////                           sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
////                           sendButton.centerYAnchor.constraint(equalTo: inputTextField.centerYAnchor),
////                           sendButton.widthAnchor.constraint(equalToConstant: 60),
////                           sendButton.heightAnchor.constraint(equalToConstant: 30)
////        ]
////        NSLayoutConstraint.activate(constraints)
////    }
