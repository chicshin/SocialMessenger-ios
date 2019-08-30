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

    var box = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        box.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        box.heightAnchor.constraint(equalToConstant: 80).isActive = true
        box.widthAnchor.constraint(equalToConstant: 80).isActive = true
        box.layer.cornerRadius = 15
        box.clipsToBounds = true
        box.image = #imageLiteral(resourceName: "Icon-App-40x40")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let vc = storyboard?.instantiateViewController(withIdentifier: "SignInTwoViewController") as! SignInTwoViewController
            navigationController?.present(vc, animated: true, completion: nil)
        } else if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "mainTabBarSegue", sender: nil)
        }
    }


}
