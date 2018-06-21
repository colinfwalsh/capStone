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
//
//struct BaseURL {
//    static let url = URL(string: "https://api.yelp.com/v3/")
//
//}
public struct YelpAPI {
    private static let baseUrlString = "https://api.yelp.com/v3/"
    
    static func getSearchData(with searchTerm: String, locationCoordinate: CLLocationCoordinate2D, onCompletion: @escaping (YelpBusinesses) -> ()) {
        let constructed = constructUrlStringWith(["term" : searchTerm, "latitude" : locationCoordinate.latitude, "longitude" : locationCoordinate.longitude], endpoint: "businesses", subEndpoint: "search")
        var request = URLRequest(url: URL(string: constructed)!)
        request.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        let session: URLSessionDataTask = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            do {
                let yelpData = try JSONDecoder().decode(YelpBusinesses.self, from: data)
                DispatchQueue.main.async {
                    onCompletion(yelpData)
                }
            } catch let error {
                print(error)
            }
            
        }
        session.resume()
    }
    
    private static func constructUrlStringWith(_ parameters: [String : Any], endpoint: String, subEndpoint: String) -> String {
        var urlString = baseUrlString + endpoint + "/" + subEndpoint + "?"
        for (key, value) in parameters {
            urlString += "\(key)=\(value)&"
        }
        return urlString
    }
}

struct YelpBusinesses: Codable {
    var businesses: [YelpBusiness]
    var total: Int
    var region: YelpRegion
}

struct YelpRegion: Codable {
    var center: YelpCoordinates
}

struct YelpCoordinates: Codable {
    var longitude: Double
    var latitude: Double
}

struct YelpCategories: Codable {
    var alias: String
    var title: String
}

struct YelpBusiness: Codable {
    var id: String
    var alias: String
    var categories: [YelpCategories]
    var coordinates: YelpCoordinates
    var display_phone: String
    var distance: Double
    var image_url: String
    var is_closed: Int
    var location: YelpLocation
    var name: String
    var phone: String
    var rating: Double
    var review_count: Int
    var transactions: [String]
    var url: String
    var price: String?
    
}

struct YelpLocation: Codable {
    var address1: String?
    var address2: String?
    var address3: String?
    var city: String
    var country: String
    var display_address: [String]
    var state: String
    var zip_code: String
}
