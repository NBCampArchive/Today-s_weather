//
//  DustResponseModel.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/14/24.
//

import Foundation

struct DustResponseModel: Decodable {
    let status: String
    let data: DataClass
}

struct DataClass: Decodable {
    let aqi: Int
    let idx: Int
    let attributions: [Attribution]
    let city: DustCity
    let dominentpol: String
    let iaqi: IAQI
    let time: Time
    let forecast: Forecast
    let debug: Debug
}

struct Attribution: Decodable {
    let url: String
    let name: String
    let logo: String?
}

struct DustCity: Decodable {
    let geo: [Double]
    let name: String
    let url: String
    let location: String
}

struct IAQI: Decodable {
    let co: AQIValue?
    let dew: AQIValue?
    let h: AQIValue?
    let no2: AQIValue?
    let o3: AQIValue?
    let p: AQIValue?
    let pm10: AQIValue?
    let pm25: AQIValue?
    let r: AQIValue?
    let so2: AQIValue?
    let t: AQIValue?
    let w: AQIValue?
}

struct AQIValue: Decodable {
    let v: Double
}

struct Time: Decodable {
    let s: String
    let tz: String
    let v: Int
    let iso: String
}

struct Forecast: Decodable {
    let daily: Daily
}

struct Daily: Decodable {
    let o3: [Pollutant]
    let pm10: [Pollutant]
    let pm25: [Pollutant]
}

struct Pollutant: Decodable {
    let avg: Int
    let day: String
    let max: Int
    let min: Int
}

struct Debug: Decodable {
    let sync: String
}
