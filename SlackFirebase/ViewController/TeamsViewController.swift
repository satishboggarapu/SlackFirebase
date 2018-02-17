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
    
    // MARK: Attributes
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        navigationController?.navigationBar.topItem?.title = "Teams"
        
//        let username = "satish"
//        let email = "satish@gmail.com"
//        let password = "satish99"
//        createUser(username: username, email: email, password: password)
//        signIn(email: email, password: password)
//        addNewTeam(teamName: "Shit", team_url: "shit.com")
    }
    
    private func postMessageToFeed() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
//            let user = MyUser(username: username)
            let title = "parth"
            let body = "parth loves drexel."
            self.writeNewPost(withUserID: userID!, username: username, title: title, body: body)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func writeNewPost(withUserID userID: String, username: String, title: String, body: String)  {
        let key = ref.child("posts").childByAutoId().key
        let post = ["uid": userID,
                    "author": username,
                    "title": title,
                    "body": body]
        let childUpdates = ["/posts/\(key)": post,
                            "/user-posts/\(userID)/\(key)": post]
        ref.updateChildValues(childUpdates)
    }

    
    func addNewTeam(teamName: String, team_url: String) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let key = self.ref.child("teams").childByAutoId().key
            let post = ["team_name": teamName,
                        "team_url": team_url]
            let childUpdates = ["/teams/\(key)": post]
            self.ref.updateChildValues(childUpdates)
        })
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
    
    // MARK: Create User Functions
    
    func createUser(username: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
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
            self.saveUserInfo(user!, withUsername: username)
        }
    }
    
    func saveUserInfo(_ user: User, withUsername username: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        
        changeRequest?.commitChanges() { (error) in
            if error != nil {
                //                print(error)
                return
            }
            self.ref.child("users").child(user.uid).setValue(["username": username])
        }
    }
    
}



