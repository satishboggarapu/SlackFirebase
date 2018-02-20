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

class TeamsViewController: UIViewController, AddNewTeamViewControllerDelegate {
    
    // MARK: UIElements
    var signOutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Attributes
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle!
    var currentUser: Member!
    var teams = [Team]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        navigationItem.setHidesBackButton(true, animated: true)
        signOutButton = UIBarButtonItem(title: "SignOut", style: .done, target: self, action: #selector(signOutButtonAction(_:)))
        navigationItem.leftBarButtonItem = signOutButton
        
        currentUser = FirebaseHelper.getCurrentUserFromDefaults()!
        navigationItem.title = currentUser.userName + " - Teams"
        getUserTeams()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func signOutButtonAction(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // listener gets called whenever the user's sign-in state changes
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            print("inside viewWillAppear")
//            if self.mybool {
//                self.checkForNewTeams()
//            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // detach the listener
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func getUserTeams() {
        ref.child(FirebaseKey.users.rawValue).child(currentUser.id).child("teams").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value is NSNull {
                print("no elements found")
                return
            }

            let data = snapshot.value as! NSDictionary
            for (teamName, teamId) in data {
                self.getTeamForId(teamId: teamId as! String)
            }
        })
    }
    
    func getTeamForId(teamId: String) {
        ref.child("teams").child(teamId).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value == nil {
                print("team does not exists for key: \(teamId)")
            }
            let data = snapshot.value as! NSDictionary
            let team = Team(jsonObject: data, teamId: teamId)
            self.teams.append(team)
            self.tableView.reloadData()
        })
    }
    
    func checkForNewTeams() {
        ref.child("users").child(currentUser.id).child("teams").observeSingleEvent(of: .childAdded, with: {(snapshot) in
            let teamId = snapshot.value as! String
            if teamId != self.teams.last?.id {
                self.getTeamForId(teamId: teamId as! String)
            }
        })
    }
    
    func deleteTeamFromFirebase(team: Team) {
        // remove from teams node
        ref.child("teams").child(team.id).removeValue()
        // remove from users team list
        ref.child("users").child(currentUser.id).child("teams").child(team.name).removeValue()
    }
    
    // MARK: AddNewTeamViewControllerDelegate
    
    func addedANewTeam() {
        checkForNewTeams()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AddNewTeamViewController {
            destinationViewController.delegate = self
        }
    }
    
}

extension TeamsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamsTableViewCell
        cell.teamNameLabel.text = teams[indexPath.row].name
        cell.teamUrlLabel.text = teams[indexPath.row].url
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteTeamFromFirebase(team: self.teams[indexPath.row])
            self.teams.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
        return [delete]
    }
}



