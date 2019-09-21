//
//  AccountViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/23/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CropViewController

extension AccountViewController {
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
     Controll TableView and NavigationBar
    */
    func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Account"
    }
    
    
    
    
    
    /*
     Control Cell TextFields
    */
    func setupTextField(cell: ProfileCell, text: String?) {
        cell.inputTextField.text = text!
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            cell.inputTextField.font = UIFont.systemFont(ofSize: 15)
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            cell.inputTextField.font = UIFont.systemFont(ofSize: 15)
            
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            cell.inputTextField.font = UIFont.systemFont(ofSize: 14)
            
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            cell.inputTextField.font = UIFont.systemFont(ofSize: 14)
            
        } else {
            cell.inputTextField.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    @objc func handleTextField(sender: UITextField) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        
        let fullnameIndexPath = IndexPath(row: 1, section: 0)
        let usernameIndexPath = IndexPath(row: 2, section: 0)
        let statusIndexPath = IndexPath(row: 4, section: 0)
        let fullnameCell = tableView.cellForRow(at: fullnameIndexPath) as! ProfileCell
        let usernameCell = tableView.cellForRow(at: usernameIndexPath) as! ProfileCell
        let statusCell = tableView.cellForRow(at: statusIndexPath) as! ProfileCell
        
        switch sender.tag {
        case 1:
            fullname = cell.inputTextField.text!
            let initCount = fullname.count
            cell.textCountLabel.text = "\(initCount)/30"
            cell.textCountLabel.isHidden = false
            usernameCell.textCountLabel.isHidden = true
            statusCell.textCountLabel.isHidden = true
        case 2:
            username = cell.inputTextField.text!
            let initCount = username.count
            cell.textCountLabel.text = "\(initCount)/25"
            cell.textCountLabel.isHidden = false
            fullnameCell.textCountLabel.isHidden = true
            statusCell.textCountLabel.isHidden = true
        case 4:
            status = cell.inputTextField.text!
            let initCount = status.count
            cell.textCountLabel.text = "\(initCount)/30"
            cell.textCountLabel.isHidden = false
            fullnameCell.textCountLabel.isHidden = true
            usernameCell.textCountLabel.isHidden = true
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        let length = cell.inputTextField.text!.count + string.utf16.count - range.length
        
        switch tag {
        case 1:
            if length <= 30 {
                return true
            } else {
                return false
            }
        case 2:
            if length <= 25 {
                return true
            } else {
                return false
            }
        case 4:
            if length <= 30 {
                return true
            } else {
                return false
            }
        default:
            break
        }
        return true
    }
    

    
    
    
    
    
    /*
     Control Edit/Done Label in cell
    */
    @objc func handleEditProfile(sender: UILabel) {
        editInAction = true
        tableView.reloadData()
    }
    
    @objc func handleDoneEdit(sender: UILabel) {
        if self.image != nil {
            self.imageStorage(onSuccess: {
            }) { (errorMessage) in
                print(errorMessage)
            }
        }
        
        Api.User.updateFullname(text: fullname)
        Api.User.updateUsername(text: username)
        Api.User.status(text: status)
        
        doneEditTriggered = true
        editInAction = false
        
        tableView.reloadData()
    }
    
    
    
    
    
    /*
     Control Keyboard
    */
    func keyboardTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
        tap.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    
    
    
    
    /*
     Control ProfileImage
    */
    func setProfileImage(cell: ProfileCell, url: URL) {
        if self.image != nil {
            cell.profileImageView.image = self.image
        } else {
            cell.profileImageView.kf.setImage(with: url)
        }
        cell.profileImageView.contentMode = .scaleAspectFill
        cell.profileImageView.clipsToBounds = true
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
        Api.User.ProfileImage(image: self.image, onSuccess: {
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
}

extension AccountViewController: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imageSelected = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: croppingStyle, image: imageSelected)
        cropController.delegate = self

        imageView.image = imageSelected
        
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
        })
    }
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
        cell.profileImageView.image = image
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
