//
//  WeatherModel.swift
//  TodayWeather
//
//  Created by 예슬 on 5/17/24.
//

import Foundation

enum WeatherModel: Int {
    case sunny = 800
    case rainy = 500
    case cloudy = 802
    case fewCloudy = 801
    
    init(id: Int) {
        switch id {
        case 200...232: self = .rainy
        case 300...321: self = .rainy
        case 500...531: self = .rainy
        case 600...622: self = .rainy
        case 701...781: self = .cloudy
        case 800: self = .sunny
        case 801: self = .fewCloudy
        case 802...804: self = .cloudy
        default: self = .sunny
        }
    }
}

