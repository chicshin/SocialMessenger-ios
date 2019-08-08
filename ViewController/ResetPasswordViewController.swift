//
//  ResetPasswordViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/4/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        setupClose()
        setupTitle()
        setupEmailTextField()
        setupReset()
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func dismissAction(_ sender: Any) {
        self.view.endEditing(true)
//        let storyboard = UIStoryboard(name: "Start", bundle: nil)
//        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        navigationController?.popViewController(animated: true)
//        navigationController!.pushViewController(signInVC, animated: true)
    }
    @IBAction func resetButtonDidTapped(_ sender: Any) {
        self.validateFields()
        Api.User.resetPassword(email: self.emailTextField.text!, onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess(SUCCESS_EMAIL_RESET)
            self.navigationController?.popViewController(animated: true)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
}
