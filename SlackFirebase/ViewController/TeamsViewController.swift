//
//  ViewController.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/16/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TeamsViewController: UIViewController {
    
    // MARK: UIElements
    var signOutButton: UIBarButtonItem!
    
    // MARK: Attributes
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!
    var currentUser: Member!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationController?.navigationBar.topItem?.title = "Teams"
        navigationItem.setHidesBackButton(true, animated: true)
        signOutButton = UIBarButtonItem(title: "SignOut", style: .done, target: self, action: #selector(signOutButtonAction(_:)))
        navigationItem.leftBarButtonItem = signOutButton
        
        currentUser = FirebaseHelper.getCurrentUserFromDefaults()!
    }
    
    @objc func signOutButtonAction(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // listener gets called whenever the user's sign-in state changes
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // detach the listener
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    

    
}



