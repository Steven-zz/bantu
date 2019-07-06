//
//  PostServices.swift
//  Bantu
//
//  Created by Steven Muliamin on 04/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

struct PostServices {
    static func getPosts(withUserID userID: String? = nil, onComplete: @escaping ([Post])->()){
        var endPointString = GlobalSession.rootUrl + "/posts/"
        if let userID = userID {
            endPointString += "user/" + userID
        }
        let url = URL(string: endPointString)
        
        let dataTask = GlobalSession.session.dataTask(with: url!) { (data, response, error) in
            if let unwrappedError = error {
                print("Error = \(unwrappedError.localizedDescription)")
            } else if let unwrappedData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                    if let dictionary = json as? [String:Any] {
                        print(dictionary)
                    }
                    let decoder = JSONDecoder()
                    let posts = try decoder.decode([Post].self, from: unwrappedData)
                    onComplete(posts)
                } catch {
                    print("Error convert JSON")
                    onComplete([])
                }
            }
        }
        dataTask.resume()
    }
    
    static func submitPost(post: Post, onComplete: @escaping (Bool) -> ()){
        let endPointString = GlobalSession.rootUrl + "/posts/"
        let url = URL(string: endPointString)
        
        var urlRequest = URLRequest.init(url: url!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonInput = post.asJSONParam
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
