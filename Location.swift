//
//  Location.swift
//  GoogleApiIntegration
//
//  Created by Sanchit Mittal on 12/10/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import ObjectMapper

class Location: Mappable {
//    var address_components: String?
    var formatted_address: String?
    var geometry: Geometry?
    var place_id: String?
    var types: [String]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
//        address_components <- map["address_components"]
        formatted_address <- map["formatted_address"]
        geometry <- map["geometry"]
        
        place_id <- map["place_id"]
        types <- map["types"]
    }
}


class Geometry: Mappable {
    var geometryLocation: GeometryLocation?
//    var bounds: String?
//    var location_type: String?
//    var viewport: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        geometryLocation <- map["location"]
//        bounds <- map["bounds"]
//        location_type <- map["location_type"]
//        viewport <- map["viewport"]
    }
}
class GeometryLocation: Mappable {
    var lat: Double?
    var lng: Double?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}
