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
    
    var users = [UserModel]()
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        doneButton.isHidden = true
    }
    
    func setupUI() {
        setupBackgroundImage()
        setupProfileImage()
        setupFullname()
        setupEditButton()
        setupDoneButton()
        setupCloseButton()
    }

    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapEdit(_ sender: Any) {
        editButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        editButton.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveChange(_ sender: Any) {
        self.imageStorage(onSuccess: {
            //changed image saved on database and storage
        }) { (errorMessage) in
            print("Something wrong1")
            ProgressHUD.showError(errorMessage)
        }
    }
}
