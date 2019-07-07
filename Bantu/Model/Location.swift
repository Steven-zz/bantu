//
//  Location.swift
//  Bantu
//
//  Created by Steven Muliamin on 03/07/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import Foundation

struct Location: Decodable {
    let areaOfInterest: String
    let name: String
    let locality: String
    let adminArea: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case areaOfInterest = "locationAOI"
        case name = "locationName"
        case locality = "locationLocality"
        case adminArea = "locationAdminArea"
        case latitude = "locationLatitude"
        case longitude = "locationLongitude"
    }
    
    init(areaOfInterest: String = "", name: String = "", locality: String = "", adminArea: String = "", latitude: Double = 0.0, longitude: Double = 0.0) {
        self.areaOfInterest = areaOfInterest
        self.name = name
        self.locality = locality
        self.adminArea = adminArea
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        areaOfInterest = try container.decode(String.self, forKey: .areaOfInterest)
        name = try container.decode(String.self, forKey: .name)
        locality = try container.decode(String.self, forKey: .locality)
        adminArea = try container.decode(String.self, forKey: .adminArea)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
}
