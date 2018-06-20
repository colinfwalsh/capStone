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
    
    public static func getSearchData(with searchTerm: String, locationCoordinate: CLLocationCoordinate2D, onCompletion: @escaping ([String : Any]) -> ()) {
        let constructed = constructUrlStringWith(["term" : searchTerm, "latitude" : locationCoordinate.latitude, "longitude" : locationCoordinate.longitude], endpoint: "businesses", subEndpoint: "search")
        var request = URLRequest(url: URL(string: constructed)!)
        request.addValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
        print(constructed)
        let session: URLSessionDataTask = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            guard let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] else {return}
            DispatchQueue.main.async {
                onCompletion(jsonData!)
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

struct Business {
    let alias: String
    let categories: [String]
    let coordinates: CLLocationCoordinate2D
    let display_phone: String
    let distance: String
    let id: String
    let image_url: String
    let is_closed: Int
    let location: YelpLocation
    let name: String
    let phone: String
    let rating: String
    let review_count: Int
    let transactions: [String]
    let url: String
}

struct YelpLocation {
    let address1: String
    let address2: String
    let address3: String
    let city: String
    let country: String
    let display_address: [String]
    let state: String
    let zip_code: Int
}
