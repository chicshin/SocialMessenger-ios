//
//  ProfileImageViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/5/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class ProfileImageViewController: UIViewController {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var image : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    func setupUI() {
        setupImageView()
        setupTitle()
        setupAddPhotoButton()
        setupSkip()
        setupDone()
    }
    
    
    @IBAction func addPhotoDidTapped(_ sender: Any) {
        submitButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        submitButton.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func skipDidTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ProfileImageToTabBarVC", sender: self)
    }
    @IBAction func doneDidTapped(_ sender: Any) {
        self.imageStorage(onSuccess: {
            self.performSegue(withIdentifier: "ProfileImageToTabBarVC", sender: self)
        }) { (errorMessage) in
            print("Something wrong1")
            ProgressHUD.showError(errorMessage)
        }
    }
}
