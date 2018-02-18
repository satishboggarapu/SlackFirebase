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
    
    public var description: String {
        var description = "Team("
        description += "id: \(self.id!),"
        description += "name: \(self.name!),"
        description += "url: \(self.url!),"
        description += "members: \(self.members!))"
        return description
    }
}
