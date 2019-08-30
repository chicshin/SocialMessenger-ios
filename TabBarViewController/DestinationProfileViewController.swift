//
//  DestinationProfileViewController.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/6/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import AlamofireImage

class DestinationProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var user: UserModel?
    var allUser: AllUserModel?
    var isSearching: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
//        setupChatButton()
        setupStatus()
        setupDestinationName()
        setupProfileImage()
        setupCloseButton()
        
    }

    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func startMessage(_ sender: Any) {
        performSegue(withIdentifier: "chatRoomSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatRoomSegue" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! ChatViewController
            if isSearching! {
                vc.allUser = self.allUser
                vc.isSearching = true
            } else if !isSearching! {
                vc.userModel = self.user
                vc.isSearching = false
            }
        }
    }
}
