//
//  TodayWeatherAPI++Bundle.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/14/24.
//

import Foundation

// API 키를 Bundle에서 가져오기 위한 확장
extension Bundle{
    
    // OpenWeatherMap API Key
    var weatherApiKey: String{
        guard let filePath = Bundle.main.path(forResource: "TodayWeatherAPI", ofType: "plist") else {
            fatalError("Couldn't find file 'TodayWeatherAPI.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "Weather_API_KEY") as? String else{
            fatalError("Couldn't find key 'API_KEY' in 'TodayWeatherAPI.plist'.")
        }
        
        return value
    }
    
    // Dust API Key
    var dustApiKey: String{
        guard let filePath = Bundle.main.path(forResource: "TodayWeatherAPI", ofType: "plist") else{
            fatalError("Couldn't find file 'TodayWeatherAPI.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "Dust_API_KEY") as? String else{
            fatalError("Couldn't find key 'API_KEY' in 'TodayWeatherAPI.plist'.")
        }
        
        return value
    }
    
}
