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
    static let rootUrl = "https://bantu.website/public"
    
    // local
//    static let rootUrl = "http://localhost/MC3-Bantu/public"

    static var selectedIndex: Int = 0
    static var currentUser: User? = nil
    
    //    static var submissions: [Post] = []
    
    static func logout() {
        try! Auth.auth().signOut()
        currentUser = nil
        didChangeUser = true
    }
    
    static func login(user: User) {
        currentUser = user
        didChangeUser = true
    }
    
    static var didChangeUser: Bool = false
    
    static func setupUser(onComplete: @escaping () -> Void) {
        if let userID = Auth.auth().currentUser?.uid {
            UserServices.getUser(withID: userID) { user in
                self.currentUser = user
                onComplete()
            }
        } else {
            onComplete()
        }
    }
}
