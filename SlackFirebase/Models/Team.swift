//
//  Team.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

public class Team: CustomStringConvertible {
    var teamID: String!
    var teamName: String!
    var teamUrl: String!
    
    init(teamID: String, teamName: String, teamUrl: String) {
        self.teamID = teamID
        self.teamName = teamName
        self.teamUrl = teamUrl
    }
    
    public var description: String {
        var description = "Team("
        description += "teamID: \(self.teamID),"
        description += "teamName: \(self.teamName),"
        description += "teamUrl: \(self.teamUrl),"
        return description
    }
}
