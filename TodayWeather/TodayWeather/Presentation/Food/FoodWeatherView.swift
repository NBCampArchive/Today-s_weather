//
//  FoodWeatherView.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//
import UIKit
import SnapKit
import Then

// 부연설명 설정 및 제약조건
class FoodWeatherView: UIView {
    let weatherImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "largeSunny")
    }
    
    let currentTemperatureLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 96)
        $0.text = "0°"
    }
    
    let weatherLine1Label = UILabel().then {
        $0.text = "OO날씨, 맛있는 선택"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    let weatherLine2Label = UILabel().then {
        $0.text = "현재 기온 0°에 먹는 맛 여기서 찾기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    let weatherLine3Label = UILabel().then {
        $0.text = "무엇을 먹을지 고민되는 하루"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.7)
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
        addSubviews(weatherImage, currentTemperatureLabel, weatherLine1Label, weatherLine2Label, weatherLine3Label)

    }
    
    private func setConstraints() {
        weatherImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(190)
            $0.leading.equalToSuperview()
            $0.width.equalTo(262)
            $0.height.equalTo(262)
        }
        
        currentTemperatureLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(166)
            $0.leading.equalToSuperview()
        }
        
        // OO날씨
        weatherLine1Label.snp.makeConstraints {
            $0.top.equalTo(currentTemperatureLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
        }
        
        // 현재기온
        weatherLine2Label.snp.makeConstraints {
            $0.top.equalTo(weatherLine1Label.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        
        // OO날씨
        weatherLine3Label.snp.makeConstraints {
            $0.top.equalTo(weatherLine2Label.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
    }
    
    func updateWeatherConstraints(topOffset: CGFloat, leadingOffset: CGFloat, width: CGFloat, height: CGFloat) {
        weatherImage.snp.updateConstraints {
            $0.top.equalToSuperview().offset(topOffset)
            $0.leading.equalToSuperview().inset(leadingOffset)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
    }
}
