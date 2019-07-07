//
//  UserServices.swift
//  Bantu
//
//  Created by Steven Muliamin on 02/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

struct UserServices {
    static func getUser(withID userID: String, onComplete: @escaping (User?)->()){
        let endPointString = GlobalSession.rootUrl + "/user/id/\(userID)"
        let url = URL(string: endPointString)
        
        let dataTask = GlobalSession.session.dataTask(with: url!) { (data, response, error) in
            if let unwrappedError = error {
                print("Error = \(unwrappedError.localizedDescription)")
            } else if let unwrappedData = data {
                do {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(User.self, from: unwrappedData)
                    onComplete(user)
                } catch {
                    print("Error convert JSON")
                    onComplete(nil)
                }
            }
        }
        dataTask.resume()
    }
    
    static func postUser(user: User, onComplete: @escaping (Bool) -> ()){
        let endPointString = GlobalSession.rootUrl + "/user/"
        let url = URL(string: endPointString)
        
        var urlRequest = URLRequest.init(url: url!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonInput = [
            "userID": user.userID,
            "roleID": user.roleID,
            "fullName": user.fullName,
            "phone": user.phone,
            "email": user.email
            ] as [String : Any]
        let data = try? JSONSerialization.data(withJSONObject: jsonInput, options: [])
        
        urlRequest.httpBody = data
        let dataTask = GlobalSession.session.dataTask(with: urlRequest) { (data, response, error) in
            if let unwrappedError = error {
                print("Error = \(unwrappedError.localizedDescription)")
                onComplete(false)
            } else if let _ = data {
                onComplete(true)
            } else {
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}
