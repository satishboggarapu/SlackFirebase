//
//  FirebaseHelper.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

public class FirebaseHelper {
    
    // Database reference
    static var ref: DatabaseReference = Database.database().reference()
    
    static func getCureentUser(uid: String, completionHandler: @escaping ((Member?) -> ())) {
        var member: Member!

        ref.child(FirebaseKey.users.rawValue).child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if snapshot.value == nil {
                completionHandler(nil)
            }
            let data = snapshot.value as! NSDictionary
            
            let name = data["name"] as! String
            let userName = data["userName"] as! String
            let email = data["email"] as! String
            member = Member(id: uid, userName: userName, name: name, email: email, password: "")
            
            completionHandler(member)
        })
    }
    
    static func saveCurrentUserToUserDefaults(uid: String, password: String) {
        ref.child(FirebaseKey.users.rawValue).child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let data = snapshot.value as! NSDictionary
            
            let name = data["name"] as! String
            let userName = data["userName"] as! String
            let email = data["email"] as! String
//            let member = Member(id: uid, userName: userName, name: name, email: email, password: "")
            let userDefaults = UserDefaults.standard
            userDefaults.set(name, forKey: Defaults.currentMemberName.rawValue)
            userDefaults.set(userName, forKey: Defaults.currentMemberUserName.rawValue)
            userDefaults.set(email, forKey: Defaults.currentMemberEmail.rawValue)
            userDefaults.set(uid, forKey: Defaults.currentMemberUid.rawValue)
            userDefaults.set(password, forKey: Defaults.currentMemberPassword.rawValue)
        })
    }
    
    static func getCurrentUserFromDefaults() -> Member? {
        let userDefaults = UserDefaults.standard
        if let name = userDefaults.value(forKey: Defaults.currentMemberName.rawValue), let userName = userDefaults.value(forKey: Defaults.currentMemberUserName.rawValue), let email = userDefaults.value(forKey: Defaults.currentMemberEmail.rawValue), let uid = userDefaults.value(forKey: Defaults.currentMemberUid.rawValue), let password = userDefaults.value(forKey: Defaults.currentMemberPassword.rawValue) {
            let member = Member(id: uid as! String, userName: userName as! String, name: name as! String, email: email as! String, password: password as! String)
            return member
        } else {
            return nil
        }
    }
}
