//
//  FoodRecommendationModel.swift
//  TodayWeather
//
//  Created by Developer_P on 5/16/24.
//

import Foundation

struct WeatherRecommendations: Codable {
    let weatherRecommendations: [String: FoodRecommendations]
}

struct FoodRecommendations: Codable {
    let korean: [String]
    let western: [String]
    let chinese: [String]
    let japanese: [String]
}
