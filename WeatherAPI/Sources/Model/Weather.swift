//
//  Weather.swift
//  WeatherAPI
//
//  Created by gnksbm on 6/5/24.
//

import Foundation

struct WeatherInfo: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

extension WeatherInfo {
    var temperature: String {
        "\(main.temp)°C"
    }
    
    var humidity: String {
        "\(main.humidity.formatted())%"
    }
    
    var windSpeed: String {
        "\(wind.speed.formatted())m/s"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}
/*
{
    "coord":{"lon":126.9778,"lat":37.5683},
    "weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],
    "base":"stations",
    "main":{"temp":294.01,"feels_like":293.93,"temp_min":290.84,"temp_max":297.81,"pressure":1017,"humidity":68},
    "visibility":10000,
    "wind":{"speed":2.57,"deg":310},
    "clouds":{"all":0},
    "dt":1717586612,
    "sys":{"type":1,"id":8105,"country":"KR","sunrise":1717531884,"sunset":1717584604},
    "timezone":32400,
    "id":1835848,
    "name":"Seoul",
    "cod":200
}
*/
