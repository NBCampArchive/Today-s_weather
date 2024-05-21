//
//  CurrentTemperatureLabel.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//

import UIKit
import Then

class CurrentTemperatureLabel: UILabel {
    init() {
        super.init(frame: .zero)
        font = BagelFatOne.regular.of(size: 96)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
