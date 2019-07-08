//
//  Event.swift
//  Bantu
//
//  Created by Steven Muliamin on 08/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

struct Event: Decodable {
    let eventID: Int
    let eventTimeStamp: String
    let eventName: String
    let startDate: String
    let endDate: String
    let description: String
    let imgUrl: String
    let fee: Double
    let feeInfo: String
    let volunteerNo: Int
    let requirements: String
    let eventNotes: String
    let eventContactNumber: String
    
    let post: Post
}
