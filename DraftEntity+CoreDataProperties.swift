//
//  DraftEntity+CoreDataProperties.swift
//  
//
//  Created by Steven Muliamin on 07/07/19.
//
//

import Foundation
import CoreData


extension DraftEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DraftEntity> {
        return NSFetchRequest<DraftEntity>(entityName: "DraftEntity")
    }

    @NSManaged public var timeStamp: String?
    @NSManaged public var schoolName: String?
    @NSManaged public var about: String?
    @NSManaged public var studentNo: Int64
    @NSManaged public var teacherNo: Int64
    @NSManaged public var address: String?
    @NSManaged public var accessNotes: String?
    @NSManaged public var notes: String?
    @NSManaged public var contactNumber: String?
    @NSManaged public var locationAOI: String?
    @NSManaged public var locationName: String?
    @NSManaged public var locationLocality: String?
    @NSManaged public var locationAdminArea: String?
    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double
    @NSManaged public var roadImages: NSData?
    @NSManaged public var schoolImages: NSData?

}
