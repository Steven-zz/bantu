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
    
    var asJSONParam: [String:Any] {
        return [
            "adminID": GlobalSession.currentUser!.userID,
            "postID": post.postID,
            "eventTimeStamp": eventTimeStamp,
            "eventName": eventName,
            "startDate": startDate,
            "endDate": endDate,
            "description": description,
            "imgUrl": imgUrl,
            "fee": fee,
            "feeInfo": feeInfo,
            "volunteerNo": volunteerNo,
            "requirements": requirements,
            "eventNotes": eventNotes,
            "eventContactNumber": eventContactNumber
        ]
    }
    
//    var asJSONParam: [String:Any] {
//        return [
//            "adminID": "3F5DTfV1jgfEsLd36Ezxz3zBmKy2",
//            "postID": 3,
//            "eventTimeStamp": "23-23-23",
//            "eventName": "please god",
//            "startDate": "awd",
//            "endDate": "awd",
//            "description": "awd",
//            "imgUrl": "awd",
//            "fee": 3,
//            "feeInfo": "awd",
//            "volunteerNo": 3,
//            "requirements": "awd",
//            "eventNotes": "awd",
//            "eventContactNumber": "awd"
//        ]
//    }
}
