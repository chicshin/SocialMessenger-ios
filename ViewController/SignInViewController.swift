//
//  ViewController.swift
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

class SignInViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if Auth.auth().currentUser != nil{
//            self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
//        }
//    }
    
    func setupUI() {
        setupTitle()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignIn()
        setupForgotPassword()
        setupSignUp()
        handleTextFields()
    }
    
    @IBAction func signInDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        signIn(onSuccess: {
//            self.performSegue(withIdentifier: "signInToTabBarVC", sender: self)
            let uid = Auth.auth().currentUser?.uid
            InstanceID.instanceID().instanceID { (result, error) in
                if let error = error {
                    print("Error fetching remote instance ID: \(error)")
                }else if let result = result{
                    Ref().databaseSpecificUser(uid: uid!).updateChildValues(["pushToken": result.token])
                }
            }
            self.performSegue(withIdentifier: "signInToTabBarVC", sender: self)
        }) { (errorMessage) in
            ProgressHUD.showError()
        }
    }
    
    
}

