//
//  AccountViewController+UI.swift
//  Tikitalka
//
//  Created by Jane Shin on 8/23/19.
//  Copyright © 2019 Jane Shin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

extension AccountViewController {
    func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Account"
    }
}
