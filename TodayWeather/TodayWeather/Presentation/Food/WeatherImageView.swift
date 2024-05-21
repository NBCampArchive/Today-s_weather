//
//  WeatherImageView.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//

import UIKit
import Then

class WeatherImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFit
        image = UIImage(named: "largeSunny")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
