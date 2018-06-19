//
//  YelpAPI.swift
//  capStone
//
//  Created by Colin Walsh on 6/18/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation
import CoreLocation
//https://api.yelp.com/v3/businesses/search?term=delis&latitude=40.7128&longitude=-74.0060

enum YelpBaseRequests {
    case businesses
    case event
    
    var endpointTerm: String {
        switch self {
        case .businesses:
            return "businesses/"
        case .event:
            return "events/"
        }
    }
}


enum YelpBusinessRequest {
    
}

struct BaseURL {
    static let url = URL(string: "https://api.yelp.com/v3/")
    
}
struct YelpAPI {
    // Pass in parameters maybe?  Then contruct linearly?
    func getSearchData(with searchTerm: String, locationCoordinate: CLLocationCoordinate2D) {
        
    }
}
