//
//  FoodLocationView.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//
import UIKit
import SnapKit
import Then

// 위치, 온도 제약조건
class FoodLocationView: UIView {
    let weatherAndLocationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading // 왼쪽 정렬
    }
    
    let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center // 가운데 정렬
    }
    
    let locationLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .firstBaseline
    }
    
    let dateLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    let locationMarkImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "locationMark")
    }
    
    let cityLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 32)
    }
    
    let countryLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
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
        locationStackView.addArrangedSubview(locationMarkImage)
        locationStackView.addArrangedSubview(locationLabelStackView)
        locationLabelStackView.addArrangedSubview(cityLabel)
        locationLabelStackView.addArrangedSubview(countryLabel)
    }
    
    private func setConstraints() {
        weatherAndLocationStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        locationMarkImage.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        locationLabelStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
    }
}
