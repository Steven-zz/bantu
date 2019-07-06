//
//  Post.swift
//  Bantu
//
//  Created by Steven Muliamin on 03/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

struct Post: Decodable {
    enum PostStatus: String {
        case accepted = "Diterima"
        case rejected = "Ditolak"
        case pending = "Sedang Diproses"
    }

    let postID: Int
    let statusID: Int
    let timeStamp: String
    let schoolName: String
    let about: String
    let studentNo: Int?
    let teacherNo: Int?
    let address: String
    let accessNotes: String
    let notes: String
    let contactNumber: String?
    let roadImages: [String]
    let schoolImages: [String]
    let location: Location
    var user: User
    
    var status: PostStatus {
        let status: PostStatus
        switch statusID {
        case 1:
            status = .accepted
        case 2:
            status = .rejected
        case 3:
            status = .pending
        default:
            status = .pending
        }
        return status
    }
    
    var asJSONParam: [String:Any] {
        return [
            "userID": user.userID,
            "statusID": statusID,
            "timeStamp": timeStamp,
            "schoolName": schoolName,
            "about": about,
            "studentNo": studentNo as Any,
            "teacherNo": teacherNo as Any,
            "address": address,
            "accessNotes": accessNotes,
            "notes": notes,
            "contactNumber": contactNumber as Any,
            "locationAOI": location.areaOfInterest,
            "locationName": location.name,
            "locationLocality": location.locality,
            "locationAdminArea": location.adminArea,
            "locationLatitude": location.latitude,
            "locationLongitude": location.longitude,
            "roadImages": roadImages,
            "schoolImages": schoolImages
        ]
    }
    
//    init(postID: Int, statusID: Int, timeStamp: String, schoolName: String, about: String, address: String, accessNotes: String, contactNumber: String, location: Location) {
//        self.postID = postID
//        self.statusID = statusID
//        self.timeStamp = timeStamp
//        self.schoolName = schoolName
//        self.about = about
//        self.address = address
//        self.accessNotes = accessNotes
//        self.contactNumber = contactNumber
//        self.location = location
//    }
}
