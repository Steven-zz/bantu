//
//  GlobalSession.swift
//  Bantu
//
//  Created by Steven Muliamin on 02/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

struct FirebaseReferences {
    static let storageRef: StorageReference = Storage.storage().reference()
}

struct GlobalSession {
    static let session = URLSession(configuration: .default)
    
    
    // domainesia
//    static let rootUrl = "https://bantu.website/public"
    
    // local
    static let rootUrl = "http://localhost/MC3-Bantu/public"

    static var selectedIndex: Int = 0
    static var currentUser: User? = nil
    
//    static var currentUser: User? = User(userID: "3F5DTfV1jgfEsLd36Ezxz3zBmKy2", roleID: 2, email: "steven@gmail.com", phone: "+6283870152354", fullName: "steven")
    
    //    static var submissions: [Post] = []
    
    static var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func setupUser() {
        if let userID = Auth.auth().currentUser?.uid {
            UserServices.getUser(withID: userID) { user in
                self.currentUser = user
            }
        }
    }
}
