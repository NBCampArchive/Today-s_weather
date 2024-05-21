//
//  CurrentWeather.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/19/24.
//

import UIKit

class CurrentWeather {
    static let shared = CurrentWeather()
    static var weather = ""
    
    func weatherImage(weather : String) -> UIImage {
        switch weather {
        case "clear sky" :
            return UIImage(named: "smallSunny") ?? UIImage()
        case "scattered clouds", "broken clouds", "thunderstorm":
            return UIImage(named: "smallCloudy") ?? UIImage()
        case "rain", "shower rain", "snow" :
            return UIImage(named: "smallRainy") ?? UIImage()
        case "few clouds" :
            return UIImage(named: "smallFewCloudy") ?? UIImage()
        default:
            return UIImage(named: "smallSunny") ?? UIImage()
        }
    }
    
    func weatherColor() -> UIColor {
        switch CurrentWeather.weather {
        case "clear sky" :
            return UIColor(named: "sunnyBackground") ?? UIColor()
        case "scattered clouds", "broken clouds", "thunderstorm":
            return UIColor(named: "cloudyBackground") ?? UIColor()
        case "rain", "shower rain", "snow" :
            return UIColor(named: "rainyBackground") ?? UIColor()
        case "few clouds" :
            return UIColor(named: "fewCloudyBackground") ?? UIColor()
        default:
            return UIColor(named: "sunnyBackground") ?? UIColor()
        }
    }
}
