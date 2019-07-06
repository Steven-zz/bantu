//
//  User.swift
//  Bantu
//
//  Created by Steven Muliamin on 02/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

class User: Decodable {
    let userID: String
    let roleID: Int
    let email: String
    let phone: String
    let fullName: String

    enum Role {
        case admin
        case publicUser
    }

    var role: Role {
        return (roleID == 1) ? .admin : .publicUser
    }

    init(userID: String, roleID: Int, email: String, phone: String, fullName: String) {
        self.userID = userID
        self.roleID = roleID
        self.email = email
        self.phone = phone
        self.fullName = fullName
    }
}
