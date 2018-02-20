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

protocol AddNewTeamViewControllerDelegate: class {
    func addedANewTeam()
}

class AddNewTeamViewController: UIViewController {

    // MARK: UIElements
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamUrlTextField: UITextField!
    
    // MARK: Attributes
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!
    var currentUser: Member!
    weak var delegate: AddNewTeamViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        doneButton.action = #selector(doneButtonAction(_:))
        currentUser = FirebaseHelper.getCurrentUserFromDefaults()!
    }

    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        let name = teamNameTextField.text!
        let url = teamUrlTextField.text!
        let team = Team(id: "", name: name, url: url, members: [:])
        addNewTeam(team: team)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Firebase
    
    func addNewTeam(team: Team) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let key = self.ref.child("teams").childByAutoId().key
            team.id = key
            let newMember = ["\(self.currentUser.userName!)": self.currentUser.id]
            let newTeam = ["team_name": team.name,
                           "team_url": team.url,
                           "members": newMember] as [String : Any]
            
            let childUpdates = ["/teams/\(key)": newTeam]
            self.ref.updateChildValues(childUpdates)
            self.addTeamToUser(team: team)
            self.delegate?.addedANewTeam()
            print("Firebase Write - Added new team")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addTeamToUser(team: Team) {
        ref.child("users").child(currentUser.id).child("teams").child(team.name).setValue(team.id)
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
