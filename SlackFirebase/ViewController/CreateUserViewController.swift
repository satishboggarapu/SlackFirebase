//
//  CreateUserViewController.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateUserViewController: UIViewController {
    
    // MARK: UIElements
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    // MARK: Attributes
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        createAccountButton.addTarget(self, action: #selector(createAccountButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc func createAccountButtonAction(_ sender: UIButton) {
        let name = nameTextField.text!
        let username = userNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let member = Member(id: "", userName: username, name: name, email: email, password: password)
        print(member)
        createUser(member: member)
        
    }

    // MARK: Create User Functions
    
    func createUser(member: Member) {
        Auth.auth().createUser(withEmail: member.email, password: member.password) { (user, error) in
            if error != nil {
                //                print(error)
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        print("email is already in use")
                    case .invalidEmail:
                        print("invalid email")
                    case .weakPassword:
                        print("weak password")
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
                
                print("could not save username")
                return
            }
            print("succesfully saved")
            self.saveUserInfo(user!, withMember: member)
            FirebaseHelper.saveCurrentUserToUserDefaults(uid: (user?.uid)!, password: member.password)
            self.performSegue(withIdentifier: "CreateUser_Teams", sender: nil)
        }
    }
    
    func saveUserInfo(_ user: User, withMember member: Member) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = member.userName
        
        changeRequest?.commitChanges() { (error) in
            if error != nil {
                //                print(error)
                return
            }
            self.ref.child("users").child(user.uid).setValue(["name": member.name,
                                                              "userName": member.userName,
                                                              "email": member.email])
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
