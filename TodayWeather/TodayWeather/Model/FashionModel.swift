//
//  FashionModel.swift
//  TodayWeather
//
//  Created by t2023-m0074 on 5/23/24.
//

import Foundation

struct WeatherClothes: Codable {
    let weatherClothes: [String: FashionRecommendations]
}

struct FashionRecommendations: Codable {
    let twentyThreeTemperatureHigher: [String]
    let sevenTeenTemperatureHigher: [String]
    let nineTemperatureHigher: [String]
    let fourTemperatureLess: [String]
}
