//
//  Member.swift
//  SlackFirebase
//
//  Created by Satish Boggarapu on 2/17/18.
//  Copyright © 2018 Satish Boggarapu. All rights reserved.
//

import Foundation

public class Member: CustomStringConvertible {
    var id: String!
    var userName: String!
    var name: String!
    var email: String!
    var password: String!
    
    init(id: String, userName: String, name: String, email: String, password: String) {
        self.id = id
        self.userName = userName
        self.name = name
        self.email = email
        self.password = password
    }
    
    public var description: String {
        var description = "Member("
        description += "id: \(self.id!),"
        description += "userName: \(self.userName!),"
        description += "name: \(self.name!),"
        description += "email: \(self.email!),"
        description += "password: \(self.password!))"
        return description
    }
    
}
