//
//  FoodLocationView.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//
import UIKit
import SnapKit
import Then

class FoodLocationView: UIView {
    let weatherAndLocationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    let locationLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .firstBaseline
        $0.distribution = .fill
    }
    
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

    let temperatureLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 32)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        addSubview(weatherAndLocationStackView)
        weatherAndLocationStackView.addArrangedSubview(dateLabel)
        weatherAndLocationStackView.addArrangedSubview(locationStackView)
        weatherAndLocationStackView.addArrangedSubview(temperatureLabel)
        
        locationStackView.addArrangedSubview(locationMarkImage)
        locationStackView.addArrangedSubview(locationLabelStackView)
        
        locationLabelStackView.addArrangedSubview(cityLabel)
        locationLabelStackView.addArrangedSubview(countryLabel)
        
    }
    
    private func setConstraints() {
        weatherAndLocationStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        locationMarkImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.greaterThanOrEqualTo(20)
        }
        
        locationLabelStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
    }
}
