//
//  WeatherLocation.swift
//  WeatherAPI
//
//  Created by gnksbm on 6/20/24.
//

import Foundation

struct WeatherLocation: Decodable {
    let name: String
    let localNames: LocalNames
    let lat: Double
    let lon: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat
        case lon
        case country
        case state
    }
}

extension WeatherLocation {
    struct LocalNames: Decodable {
        let en: String
        let zh: String
        
        enum CodingKeys: String, CodingKey {
            case en
            case zh
        }
    }
}

/*
{
    "name":"Cupertino",
    "local_names": {
        "en": "Cupertino",
        "zh": "库柏蒂诺"
    },
    "lat": 37.3228934,
    "lon": -122.0322895,
    "country": "US",
    "state": "California"
}
*/
