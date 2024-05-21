//
//  WeatherAndLocationStackView.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//

import UIKit
import SnapKit
import Then

class WeatherAndLocationStackView: UIStackView {
    
    let dateLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 17)
    }
    
    let locationMarkImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "locationMark")
    }
    
    let cityLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 32)
    }
    
    let countryLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 15)
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 4
        
        let locationStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 4
        }
        
        let locationLabelStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .firstBaseline
        }
        
        locationStackView.addArrangedSubview(locationMarkImage)
        locationStackView.addArrangedSubview(locationLabelStackView)
        
        locationLabelStackView.addArrangedSubview(cityLabel)
        locationLabelStackView.addArrangedSubview(countryLabel)
        
        addArrangedSubview(dateLabel)
        addArrangedSubview(locationStackView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
