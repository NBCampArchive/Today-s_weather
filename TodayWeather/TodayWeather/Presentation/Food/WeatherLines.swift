//
//  WeatherLines.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//

import UIKit
import Then

class WeatherLines: UIStackView {
    
    let weatherLine1Label = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    let weatherLine2Label = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    let weatherLine3Label = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 10
        
        addArrangedSubview(weatherLine1Label)
        addArrangedSubview(weatherLine2Label)
        addArrangedSubview(weatherLine3Label)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
