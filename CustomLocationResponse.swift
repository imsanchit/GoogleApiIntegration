//
//  CustomLocationResponse.swift
//  GoogleApiIntegration
//
//  Created by Sanchit Mittal on 12/10/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import Foundation
import ObjectMapper

class CustomLocationResponse: Mappable {
    
    var results: [Location]?
    var status: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        results <- map["results"]
        status <- map["status"]
    }
}
