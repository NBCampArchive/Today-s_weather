//
//  ForecastResponseModel.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/14/24.
//

import Foundation

struct ForecastResponseModel: Decodable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [ForecastItem]
    let city: City
}

struct City: Decodable {
    let id: Int
    let name: String
    let coord: ForecastCoord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct ForecastCoord: Decodable {
    let lat: Double
    let lon: Double
}

struct ForecastItem: Decodable {
    let dt: TimeInterval
    let main: ForecastMain
    let weather: [ForecastWeather]
    let clouds: ForecastClouds
    let wind: ForecastWind
    let visibility: Int
    let pop: Double
    let rain: ForecastRain?
    let sys: ForecastSys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct ForecastMain: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case tempKf = "temp_kf"
    }
}

struct ForecastWeather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct ForecastClouds: Decodable {
    let all: Int
}

struct ForecastWind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct ForecastRain: Decodable {
    let threeHour: Double?

    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}

struct ForecastSys: Decodable {
    let pod: String
}

