//
//  EventServices.swift
//  Bantu
//
//  Created by Steven Muliamin on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

struct EventServices {
    static func getEvents(onComplete: @escaping ([Event])->()){
        let endPointString = GlobalSession.rootUrl + "/events/"
        let url = URL(string: endPointString)
        
        let dataTask = GlobalSession.session.dataTask(with: url!) { (data, response, error) in
            if let unwrappedError = error {
                print("Error = \(unwrappedError.localizedDescription)")
            } else if let unwrappedData = data {
                do {
                    let decoder = JSONDecoder()
                    let events = try decoder.decode([Event].self, from: unwrappedData)
                    onComplete(events)
                } catch {
                    print("Error convert JSON")
                    onComplete([])
                }
            }
        }
        dataTask.resume()
    }
    
    static func submitEvent(event: Event, onComplete: @escaping (Bool) -> ()){
        let endPointString = GlobalSession.rootUrl + "/events/"
        let url = URL(string: endPointString)
        
        var urlRequest = URLRequest.init(url: url!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonInput = event.asJSONParam
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
