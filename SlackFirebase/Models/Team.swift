//
//  Team.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

public class Team: CustomStringConvertible {
    var id: String!
    var name: String!
    var url: String!
    var members: [String: String]!
    
    init(id: String, name: String, url: String, members: [String: String]) {
        self.id = id
        self.name = name
        self.url = url
        self.members = members
    }
    
    init(jsonObject: NSDictionary, teamId: String) {
        self.id = teamId
        self.name = jsonObject.value(forKey: "team_name") as! String
        self.url = jsonObject.value(forKey: "team_url") as! String
        self.members = jsonObject.value(forKey: "members") as! [String: String]
    }
    
    public var description: String {
        var description = "Team("
        description += "id: \(self.id!),"
        description += "name: \(self.name!),"
        description += "url: \(self.url!),"
        description += "members: \(self.members!))"
        return description
    }
}
