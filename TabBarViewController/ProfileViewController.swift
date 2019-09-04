//
//  ProfileViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD
import Alamofire
import AlamofireImage
import CropViewController

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var editProfileImage: UIImageView!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var textFieldUnderlinde: UIView!
    @IBOutlet weak var textCountLabel: UILabel!
    
    var blurBackground: UIVisualEffectView?
    var textFieldFrame: CGRect?
    var users = [UserModel]()
    var imageSelected: UIImage? = nil
    var statusText: String? = nil

    let imageView = UIImageView()
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTextField.delegate = self
        
        setupUI()
        tapRecognizerAction()
        
        textCountLabel.isHidden = true
        doneButton.isHidden = true
        editProfileImage.isHidden = true
        statusTextField.isHidden = true
        textFieldUnderlinde.isHidden = true
    }
    
    func setupUI() {
        setupBackgroundImage()
        setupProfileImage()
        setupFullname()
        setupStatusLabel()
        setupEditButton()
        setupDoneButton()
        setupCloseButton()
        editStatusTextField()
        setupEditProfileImage()

    }
    
    func tapRecognizerAction() {
        didTapEditButton()
        didTapEditProfileImage()
        didTapTextField()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.removeBlurEffect()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func didTapEditButton() {
        editButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editDidStart))
        editButton.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveChange(_ sender: Any) {
        self.view.endEditing(true)
        self.updateChangedValues()
        profileImage.image = imageSelected
        self.statusLabel.text = self.statusText
        self.imageStorage(onSuccess: {
            //changed image saved on database and storage
        }) { (errorMessage) in
            print("Something wrong1")
            ProgressHUD.showError(errorMessage)
        }
        
        statusLabel.isHidden = false
        editImage.isHidden = false
        editButton.isHidden = false
        
        editProfileImage.isHidden = true
        statusTextField.isHidden = true
        textFieldUnderlinde.isHidden = true
        textCountLabel.isHidden = true
        
        doneButton.isHidden = true
    }
}
