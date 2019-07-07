//
//  DraftEntityModel.swift
//  Bantu
//
//  Created by Steven Muliamin on 07/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation
import UIKit

struct DraftEntityModel {
    let timeStamp: String
    let schoolName: String
    let about: String
    let studentNo: Int
    let teacherNo: Int
    let address: String
    let accessNotes: String
    let notes: String
    let contactNumber: String
    let locationAOI: String
    let locationName: String
    let locationLocality: String
    let locationAdminArea: String
    let locationLatitude: Double
    let locationLongitude: Double
    let roadImages: [UIImage]
    let schoolImages: [UIImage]
}
