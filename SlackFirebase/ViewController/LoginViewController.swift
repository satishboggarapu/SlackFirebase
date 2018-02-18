//
//  LoginViewController.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/16/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var defaultLoginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Attributes
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        signInButton.addTarget(self, action: #selector(signInButtonAction(_:)), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(createAccountButtonAction(_:)), for: .touchUpInside)
        defaultLoginButton.addTarget(self, action: #selector(defaultLoginButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc func signInButtonAction(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        signIn(email: email, password: password)
    }
    
    @objc func createAccountButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: "signUpSegue", sender: nil)
    }
    
    @objc func defaultLoginButtonAction (_ sender: UIButton) {
        let email = "satish@gmail.com"
        let password = "satish99"
        signIn(email: email, password: password)
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("invalid login")
                return
            }
            print("logged in")
            FirebaseHelper.saveCurrentUserToUserDefaults(uid: (user?.uid)!, password: password)
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "loginSeque" {
//            if let vc = segue.destination as? TeamsViewController {
//                vc.currentUser =
//            }
//        }
    }
    

}
