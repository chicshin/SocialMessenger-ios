//
//  toremove2.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/12/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import Foundation

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
