//
//  ProfileViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import AlamofireImage
import CropViewController
import ProgressHUD

extension ProfileViewController {
    /* Control Flagged Users */
    func signOutFlaggedUserAlert() {
        let alert = UIAlertController(title: "Error", message: "Your account has been disabled for violating our terms.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.handleSignOut()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func handleSignOut() {
        let moreVC = MoreViewController()
        moreVC.removePushToken()
        do {
            try Auth.auth().signOut()
        } catch let logutError {
            print(logutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
    
    
    
    /*
        Control Profile Image
    */
    func setupProfileImage() {
        let uid = Auth.auth().currentUser?.uid
        
        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
            if let dict = dataSnapShot.value as? [String:Any] {
                let name = dict["fullname"] as! String
                self.nameLabel.text = name
                let urlString = dict["profileImageUrl"] as! String
                let url = URL(string: urlString)
                self.profileImage.kf.setImage(with: url)
            }
        })
    }
    
    
    
    
    
    /*
     Control Edit Profile Image
     */
    func didTapEditProfileImage() {
        addPhotoView.isUserInteractionEnabled = true
        profileImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        addPhotoView.addGestureRecognizer(tapGesture)
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker() {
        self.croppingStyle = .default
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imageStorage(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Api.User.ProfileImage(image: self.imageSelected, onSuccess: {
            self.doneButton.isHidden = true
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
    
    
    
    
    
    /*
        Control Start Edit Activity
    */

    @objc func editDidStart() {
        
        showDoneButton()
        addPhotoImageView.isHidden = false
        addPhotoView.isHidden = false
        statusTextField.isHidden = false
        statusLabel.isHidden = true
        editImage.isHidden = true
        editButton.isHidden = true
        textFieldUnderline.isHidden = false
    }
    
    
    
    
    
    /*
        Control Status
    */
    func setupStatusLabel() {
        let uid = Auth.auth().currentUser?.uid
        
        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
            if let dict = dataSnapShot.value as? [String:Any] {
                guard let status = dict["status"] as? String else {
                    self.statusLabel.text = ""
                    return
                }
                self.statusLabel.text = status
                self.statusTextField.text = status
            }
        })
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        removeBlurEffect()
        return true
    }

    func updateChangedValues() {
        self.statusText = self.statusTextField.text!
        Api.User.status(text: statusText!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        statusTextField.textColor = .white
        let length = self.statusTextField.text!.count + string.utf16.count - range.length
        textCountLabel.isHidden = false
        if length <= 30 {
            self.textCountLabel.text = "\(length)/30"
            return true
        } else {
            print("text count out of range")
            return false
        }
    }

    func didTapTextField() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showBlurredBackground))
        statusTextField.addGestureRecognizer(tapGesture)
    }

    @objc func showBlurredBackground() {
        statusTextField.becomeFirstResponder()
        setBlurBackground()
    }

    
    
    
    
    /*
        Control Done Activity
    */
    
    @objc func showDoneButton() {
        doneButton.isHidden = false
    }


    
    
    
    /*
        Setup Other Fixed Fields
    */

    func setupFullname() {
        let uid = Auth.auth().currentUser?.uid
        
        Ref().databaseSpecificUser(uid: uid!).observe(.value, with: { (dataSnapShot: DataSnapshot) in
            if let dict = dataSnapShot.value as? [String:Any] {
                let name = dict["fullname"] as! String
                self.nameLabel.text = name
            }
        })
    }
    
    
    
    

    /*
        Control Blur Effect
    */
    func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeBlurEffect)))
        view.addSubview(blurEffectView)
        view.addSubview(statusTextField)
        view.addSubview(textFieldUnderline)
        view.addSubview(textCountLabel)
    }

    @objc func removeBlurEffect() {
        let blurredEffectViews = view.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
            statusTextField.textColor = .black
        }
    }
}

extension ProfileViewController: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        imageSelected = image
        profileImage.image = imageSelected
        
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
        })
        
        showDoneButton()
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        layoutImageView()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: { self.imageView.isHidden = false })
        }
        else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func layoutImageView() {
        guard imageView.image != nil else { return }
        
        let padding: CGFloat = 20.0
        
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    
    @objc public func sharePhoto() {
        guard let image = imageView.image else {
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem!
        present(activityController, animated: true, completion: nil)
    }

}

extension UIImageView {
    func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.7
        self.addSubview(blurEffectView)
    }
}

extension UIView {
    /// Remove UIBlurEffect from UIView
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
}
