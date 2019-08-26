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

class ProfileViewController: UIViewController {

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

    var users = [UserModel]()
    var image: UIImage? = nil
    var statusText: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        setupStatusUnderline()
        setupEditProfileImage()
        didTapEditButton()
        didTapEditProfileImage() 
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func didTapEditButton() {
        editButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editDidStart))
        editButton.addGestureRecognizer(tapGesture)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
//        editButton.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveChange(_ sender: Any) {
        self.view.endEditing(true)
        self.updateChangedValues()
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
        
        doneButton.isHidden = true
    }
}
