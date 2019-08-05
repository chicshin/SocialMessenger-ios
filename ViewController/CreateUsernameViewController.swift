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


class CreateUsernameViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameErrorMessageLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonTopLayout: NSLayoutConstraint!
    
    var usernameSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        setupTitle()
        setupInitialError()
        setupUsernameTextField()
        setupSignIn()
        setupNext()
        handleTextFields()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.usernameSelected = usernameTextField.text!
        createUsername(onSuccess: {
            self.performSegue(withIdentifier: "usernameSegue", sender: self)
        }) { (errorMessage) in
            self.setupErrorLabel()
            self.handleError()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "usernameSegue" {
            let vc = segue.destination as! SignUpViewController
            vc.usernameReceived = self.usernameSelected
        }
    }
    
    @IBAction func signInDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}
