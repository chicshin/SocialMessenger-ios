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


//
//  ProfileViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//import Alamofire
//import AlamofireImage
//import CropViewController
//import ProgressHUD
//
//extension ProfileViewController {
//    /*
//     Control Profile Image
//     */
//    func setupProfileImage() {
//        let uid = Auth.auth().currentUser?.uid
//        
//        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
//            if let dict = dataSnapShot.value as? [String:Any] {
//                let name = dict["fullname"] as! String
//                self.nameLabel.text = name
//                let urlString = dict["profileImageUrl"] as! String
//                let url = URL(string: urlString)
//                self.profileImage.kf.setImage(with: url)
//            }
//        })
//        profileImage.layer.cornerRadius = profileImage.frame.width/2
//        profileImage.clipsToBounds = true
//        profileImage.contentMode = .scaleAspectFill
//    }
//    
//    
//    
//    
//    
//    /*
//     Control Edit Profile Image
//     */
//    func didTapEditProfileImage() {
//        editProfileImage.isUserInteractionEnabled = true
//        profileImage.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
//        editProfileImage.addGestureRecognizer(tapGesture)
//        profileImage.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func presentPicker() {
//        self.croppingStyle = .default
//        let picker = UIImagePickerController()
//        picker.allowsEditing = false
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        self.present(picker, animated: true, completion: nil)
//    }
//    
//    func imageStorage(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
//        Api.User.ProfileImage(image: self.imageSelected, onSuccess: {
//            self.doneButton.isHidden = true
//            onSuccess()
//        }) { (errorMessage) in
//            onError(errorMessage)
//        }
//    }
//    
//    func setupEditProfileImage() {
//        editProfileImage.image = UIImage(imageLiteralResourceName: "add_circle")
//        editProfileImage.layer.cornerRadius = 25/2
//        editProfileImage.clipsToBounds = true
//        editProfileImage.backgroundColor = .white
//    }
//    
//    
//    
//    
//    
//    /*
//     Control Start Edit Activity
//     */
//    func setupEditButton() {
//        editButton.tintColor = .darkGray
//        editButton.titleLabel?.text = "Edit Profile"
//        //        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        editButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
//        editImage.image = #imageLiteral(resourceName: "edit")
//    }
//    @objc func editDidStart() {
//        
//        showDoneButton()
//        editProfileImage.isHidden = false
//        //        doneButton.isHidden = false
//        statusTextField.isHidden = false
//        statusLabel.isHidden = true
//        editImage.isHidden = true
//        editButton.isHidden = true
//        textFieldUnderlinde.isHidden = false
//    }
//    
//    
//    
//    
//    
//    /*
//     Control Status
//     */
//    func setupStatusLabel() {
//        let uid = Auth.auth().currentUser?.uid
//        
//        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
//            if let dict = dataSnapShot.value as? [String:Any] {
//                guard let status = dict["status"] as? String else {
//                    self.statusLabel.text = ""
//                    return
//                }
//                self.statusLabel.text = status
//                self.statusLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
//                //                self.statusLabel.font = UIFont.systemFont(ofSize: 15)
//                self.statusLabel.textAlignment = .center
//            }
//        })
//        textFieldUnderlinde.backgroundColor = .lightGray
//    }
//    
//    func editStatusTextField() {
//        statusTextField.borderStyle = .none
//        let placeholderAttr = NSMutableAttributedString(string: "Please type status", attributes:
//            [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
//        statusTextField.attributedPlaceholder = placeholderAttr
//        statusTextField.textAlignment = .center
//        statusTextField.font = UIFont.systemFont(ofSize: 15)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        view.endEditing(true)
//        removeBlurEffect()
//        return true
//    }
//    
//    func updateChangedValues() {
//        self.statusText = self.statusTextField.text!
//        Api.User.status(text: statusText!)
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        statusTextField.textColor = .white
//        let length = self.statusTextField.text!.count + string.utf16.count - range.length
//        textCountLabel.isHidden = false
//        if length <= 30 {
//            self.textCountLabel.text = "\(length)/30"
//            self.textCountLabel.font = UIFont.systemFont(ofSize: 13)
//            self.textCountLabel.textColor = .lightGray
//            return true
//        } else {
//            print("text count out of range")
//            return false
//        }
//    }
//    
//    func didTapTextField() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showBlurredBackground))
//        statusTextField.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func showBlurredBackground() {
//        statusTextField.becomeFirstResponder()
//        setBlurBackground()
//    }
//    
//    
//    
//    
//    
//    /*
//     Control Done Activity
//     */
//    func setupDoneButton() {
//        let title = "Done"
//        let attributedText = NSMutableAttributedString(string: title, attributes:
//            [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
//        doneButton.setAttributedTitle(attributedText, for: UIControl.State.normal)
//    }
//    
//    @objc func showDoneButton() {
//        doneButton.isHidden = false
//    }
//    
//    
//    
//    
//    
//    /*
//     Setup Other Fixed Fields
//     */
//    func setupCloseButton() {
//        closeButton.setImage(#imageLiteral(resourceName: "close_icon"), for: UIControl.State.normal)
//        closeButton.tintColor = .black
//    }
//    func setupBackgroundImage() {
//        backgroundImage.clipsToBounds = true
//    }
//    func setupFullname() {
//        let uid = Auth.auth().currentUser?.uid
//        
//        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
//            if let dict = dataSnapShot.value as? [String:Any] {
//                let name = dict["fullname"] as! String
//                self.nameLabel.text = name
//                self.nameLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 20)
//                self.nameLabel.textAlignment = .center
//            }
//        })
//    }
//    
//    
//    
//    
//    
//    /*
//     Control Blur Effect
//     */
//    func setBlurBackground() {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.alpha = 1
//        //        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeBlurEffect)))
//        view.addSubview(blurEffectView)
//        view.addSubview(statusTextField)
//        view.addSubview(textFieldUnderlinde)
//        view.addSubview(textCountLabel)
//    }
//    
//    @objc func removeBlurEffect() {
//        let blurredEffectViews = view.subviews.filter{$0 is UIVisualEffectView}
//        blurredEffectViews.forEach{ blurView in
//            blurView.removeFromSuperview()
//            statusTextField.textColor = .black
//        }
//    }
//}
//
//extension ProfileViewController: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
//        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
//        cropController.delegate = self
//        
//        imageSelected = image
//        profileImage.image = imageSelected
//        
//        picker.dismiss(animated: true, completion: {
//            self.present(cropController, animated: true, completion: nil)
//        })
//        
//        //        dismiss(animated: true, completion: nil)
//        showDoneButton()
//    }
//    
//    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        self.croppedRect = cropRect
//        self.croppedAngle = angle
//        updateImageViewWithImage(image, fromCropViewController: cropViewController)
//    }
//    
//    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
//        imageView.image = image
//        layoutImageView()
//        
//        self.navigationItem.rightBarButtonItem?.isEnabled = true
//        
//        if cropViewController.croppingStyle != .circular {
//            imageView.isHidden = true
//            
//            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
//                                                   toView: imageView,
//                                                   toFrame: CGRect.zero,
//                                                   setup: { self.layoutImageView() },
//                                                   completion: { self.imageView.isHidden = false })
//        }
//        else {
//            self.imageView.isHidden = false
//            cropViewController.dismiss(animated: true, completion: nil)
//        }
//    }
//    
//    public func layoutImageView() {
//        guard imageView.image != nil else { return }
//        
//        let padding: CGFloat = 20.0
//        
//        var viewFrame = self.view.bounds
//        viewFrame.size.width -= (padding * 2.0)
//        viewFrame.size.height -= ((padding * 2.0))
//        
//        var imageFrame = CGRect.zero
//        imageFrame.size = imageView.image!.size;
//        
//        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
//            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
//            imageFrame.size.width *= scale
//            imageFrame.size.height *= scale
//            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
//            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
//            imageView.frame = imageFrame
//        }
//        else {
//            self.imageView.frame = imageFrame;
//            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
//        }
//    }
//    
//    @objc public func sharePhoto() {
//        guard let image = imageView.image else {
//            return
//        }
//        
//        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem!
//        present(activityController, animated: true, completion: nil)
//    }
//    
//}
//
//extension UIImageView {
//    func setBlurBackground() {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.alpha = 0.7
//        self.addSubview(blurEffectView)
//    }
//}
//
//extension UIView {
//    /// Remove UIBlurEffect from UIView
//    func removeBlurEffect() {
//        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
//        blurredEffectViews.forEach{ blurView in
//            blurView.removeFromSuperview()
//        }
//    }
//}
