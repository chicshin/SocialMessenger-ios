//
//  SignUpViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/3/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class SignUpViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fullnameContainerView: UIView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var usernameReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = usernameReceived
        setupUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupUI() {
        setupBackButton()
        setupTitle()
        setupFullnameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupSubmitButton()
        hideUsername()
        handleTextFields()
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        signUp(onSuccess: {
            self.performSegue(withIdentifier: "ProfileImageSegue", sender: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }

}
