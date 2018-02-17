//
//  AddNewTeamViewController.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddNewTeamViewController: UIViewController {

    // MARK: UIElements
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamUrlTextField: UITextField!
    
    // MARK: Attributes
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        doneButton.action = #selector(doneButtonAction(_:))
    }

    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        let name = teamNameTextField.text!
        let url = teamUrlTextField.text!
        let team = Team(teamID: "", teamName: name, teamUrl: url)
        addNewTeam(team: team)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Firebase
    
    func addNewTeam(team: Team) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let key = self.ref.child("teams").childByAutoId().key
            let post = ["team_name": team.teamName,
                        "team_url": team.teamUrl]
            let childUpdates = ["/teams/\(key)": post]
            self.ref.updateChildValues(childUpdates)
            print("Firebase Write - Added new team")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
