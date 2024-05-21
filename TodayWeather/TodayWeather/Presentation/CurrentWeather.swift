//
//  CurrentWeather.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/19/24.
//

import UIKit

class CurrentWeather {
    static let shared = CurrentWeather()
    static var id = 0
    
    func weatherImage(weather : Int) -> UIImage {
        let weatherState = WeatherModel(id: CurrentWeather.id)
        switch weatherState {
        case .sunny :
            return UIImage(named: "smallSunny") ?? UIImage()
        case .cloudy:
            return UIImage(named: "smallCloudy") ?? UIImage()
        case .rainy :
            return UIImage(named: "smallRainy") ?? UIImage()
        case .fewCloudy :
            return UIImage(named: "smallFewCloudy") ?? UIImage()
        }
    }
    
    func weatherColor() -> UIColor {
        let weatherState = WeatherModel(id: CurrentWeather.id)
        switch weatherState {
        case .sunny :
            return UIColor(named: "sunnyBackground") ?? UIColor()
        case .cloudy:
            return UIColor(named: "cloudyBackground") ?? UIColor()
        case .rainy :
            return UIColor(named: "rainyBackground") ?? UIColor()
        case .fewCloudy :
            return UIColor(named: "fewCloudyBackground") ?? UIColor()
        }
    }
}
