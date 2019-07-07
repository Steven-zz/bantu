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

    var user: User? = nil
    let postID: Int
    let statusID: Int
    let timeStamp: String
    let schoolName: String
    let about: String
    let address: String
    let accessNotes: String
    let contactPersonName: String?
    let contactNumber: String?
    let location: Location
    
    var status: PostStatus {
        switch statusID {
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            break
        }
        return .pending
    }
    
    enum CodingKeys: String, CodingKey {
        case user
        case postID
        case statusID
        case timeStamp
        case schoolName
        case about
        case address
        case accessNotes
        case contactPersonName = "contactPerson"
        case contactNumber
        case location
    }
    
    init(postID: Int = 0, statusID: Int = 0, timeStamp: String = "", schoolName: String = "", about: String = "", address: String = "", accessNotes: String = "", contactPersonName: String = "", contactNumber: String = "", location: Location = Location()) {
        self.postID = postID
        self.statusID = statusID
        self.timeStamp = timeStamp
        self.schoolName = schoolName
        self.about = about
        self.address = address
        self.accessNotes = accessNotes
        self.contactPersonName = contactPersonName
        self.contactNumber = contactNumber
        self.location = location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user = try container.decode(User.self, forKey: .user)
        postID = try container.decode(Int.self, forKey: .postID)
        statusID = try container.decode(Int.self, forKey: .statusID)
        timeStamp = try container.decode(String.self, forKey: .timeStamp)
        schoolName = try container.decode(String.self, forKey: .schoolName)
        about = try container.decode(String.self, forKey: .about)
        address = try container.decode(String.self, forKey: .address)
        accessNotes = try container.decode(String.self, forKey: .accessNotes)
        contactPersonName = try container.decode(String.self, forKey: .contactPersonName)
        contactNumber = try container.decode(String.self, forKey: .contactNumber)
        location = try container.decode(Location.self, forKey: .location)
    }
}
