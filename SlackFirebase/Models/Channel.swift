//
//  Channel.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

public class Channel: CustomStringConvertible {
    var id: String!
    var teamId: String!
    var name: String!
//    var chatID: String!
    var members: [Member]!
    
    init(id: String, teamId: String, name: String, members: [Member]) {
        self.id = id
        self.teamId = teamId
        self.name = name
        self.members = members
    }
    
    public var description: String {
        var description = "Channel("
        description += "id: \(self.id!),"
        description += "teaemId: \(self.teamId!),"
        description += "name: \(self.name!),"
        description += "memebers: \(self.members!))"
        return description
    }
    
}
