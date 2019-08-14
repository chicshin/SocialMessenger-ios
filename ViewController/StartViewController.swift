//
//  StartViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/13/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            navigationController?.present(vc, animated: true, completion: nil)
        } else if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "mainTabBarSegue", sender: nil)
        }
    }


}
