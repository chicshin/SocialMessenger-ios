//
//  ProfileImageViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import CropViewController


extension ProfileImageViewController {
    /*
     Control Blur Background
     */
    func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurBackground = UIVisualEffectView(effect: blurEffect)
        blurBackground!.frame = view.bounds
        blurBackground!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurBackground!.alpha = 1
        view.addSubview(blurBackground!)
        view.addSubview(welcomeLabel)
        view.addSubview(usernameLabel)
        view.addSubview(doneButton)
        view.addSubview(profileImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(setImageButton)
        view.addSubview(skipButton)
    }
    
    func loadWelcomeMessage() {
        usernameLabel.text = usernameReceived
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurBackground?.alpha = 0
            self.doneButton.alpha = 0
            self.profileImageView.alpha = 0
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.setImageButton.alpha = 0
            self.skipButton.alpha = 0
            self.welcomeLabel.alpha = 0.8
            self.usernameLabel.alpha = 0.8
            self.welcomeLabel.isHidden = false
            self.usernameLabel.isHidden = false
        }, completion: nil)
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
    
    func setupConstraints() {
        if UIDevices.modelName == "iPhone XS Max" || UIDevices.modelName == "iPhone XR" {
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 43).isActive = true
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            profileImageView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 70).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 315).isActive = true
            
            setImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30).isActive = true
            setImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            setImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            setImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            skipButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            //        welcomeUsernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            welcomeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            welcomeLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
            
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            usernameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        }
        else if UIDevices.modelName == "iPhone 6 Plus" || UIDevices.modelName == "iPhone 6s Plus" || UIDevices.modelName == "iPhone 7 Plus" || UIDevices.modelName == "iPhone 8 Plus"{
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 15).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            profileImageView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 70).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 315).isActive = true
            
            setImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30).isActive = true
            setImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            setImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            setImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            skipButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            //        welcomeUsernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            welcomeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            welcomeLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
            
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            usernameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        } else if UIDevices.modelName == "iPhone X" || UIDevices.modelName == "iPhone XS" {
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            profileImageView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 70).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            
            setImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30).isActive = true
            setImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            setImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            setImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            skipButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            welcomeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            welcomeLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
            
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            usernameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        } else if UIDevices.modelName == "iPhone 6" || UIDevices.modelName == "iPhone 6s" || UIDevices.modelName == "iPhone 7" || UIDevices.modelName == "iPhone 8"{
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            profileImageView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 70).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            
            setImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30).isActive = true
            setImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            setImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            setImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            skipButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            welcomeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            welcomeLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
            
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            usernameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        } else {
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            profileImageView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 70).isActive = true
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: 220).isActive = true
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subtitleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
            
            setImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30).isActive = true
            setImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            setImageButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
            setImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            skipButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            //        welcomeUsernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            welcomeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            welcomeLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
            
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            usernameLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor).isActive = true
            usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            usernameLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        }
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
    }
}

extension ProfileImageViewController: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imageSelected = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        let cropController = CropViewController(croppingStyle: croppingStyle, image: imageSelected)
        cropController.delegate = self
        
        image = imageSelected
        self.profileImageView.image = image
        
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
        })
        doneButton.isHidden = false
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        self.image = image
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
