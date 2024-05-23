//
//  WeatherDataManager.swift
//  TodayWeather
//
//  Created by 예슬 on 5/21/24.
//

import Combine

class WeatherDataManager {
    static let shared = WeatherDataManager()
    
    @Published var weatherData: CurrentResponseModel?
    
    private init() {}
}
