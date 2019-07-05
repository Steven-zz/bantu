//
//  GlobalSession.swift
//  Bantu
//
//  Created by Steven Muliamin on 02/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import FirebaseAuth

struct GlobalSession {
    static let session = URLSession(configuration: .default)
    static let rootUrl = "https://bantu.website/public"
    
    static var currentUser: User?
    
    //    static var submissions: [Post] = []
    
    static var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
