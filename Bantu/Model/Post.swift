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
    let studentNo: Int
    let teacherNo: Int
    let address: String
    let accessNotes: String
    let notes: String
    let contactNumber: String
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
            "studentNo": studentNo,
            "teacherNo": teacherNo,
            "address": address,
            "accessNotes": accessNotes,
            "notes": notes,
            "contactNumber": contactNumber,
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
    
    init(postID: Int = 0, statusID: Int = 0, timeStamp: String = "", schoolName: String = "", about: String = "", teacherNo: Int = 0, studentNo: Int = 0, address: String = "", accessNotes: String = "", notes:String = "", contactNumber: String = "", roadImages: [String] = [String](), schoolImages:[String] = [String](), location: Location = Location(), user: User = User()) {
        self.postID = postID
        self.statusID = statusID
        self.timeStamp = timeStamp
        self.schoolName = schoolName
        self.about = about
        self.teacherNo = teacherNo
        self.studentNo = studentNo
        self.address = address
        self.accessNotes = accessNotes
        self.notes = notes
        self.contactNumber = contactNumber
        self.roadImages = roadImages
        self.schoolImages = schoolImages
        self.location = location
        self.user = user
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        user = try container.decode(User.self, forKey: .user)
//        postID = try container.decode(Int.self, forKey: .postID)
//        statusID = try container.decode(Int.self, forKey: .statusID)
//        timeStamp = try container.decode(String.self, forKey: .timeStamp)
//        schoolName = try container.decode(String.self, forKey: .schoolName)
//        about = try container.decode(String.self, forKey: .about)
//        address = try container.decode(String.self, forKey: .address)
//        accessNotes = try container.decode(String.self, forKey: .accessNotes)
//        contactPersonName = try container.decode(String.self, forKey: .contactPersonName)
//        contactNumber = try container.decode(String.self, forKey: .contactNumber)
//        location = try container.decode(Location.self, forKey: .location)
//    }
}
