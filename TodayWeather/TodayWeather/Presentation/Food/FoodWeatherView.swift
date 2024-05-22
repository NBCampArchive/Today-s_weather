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
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    let weatherLine2Label = UILabel().then {
        $0.text = "현재 기온 0°에 먹는 맛 여기서 찾기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    let weatherLine3Label = UILabel().then {
        $0.text = "무엇을 먹을지 고민되는 하루"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
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
        addSubview(weatherImage)
        addSubview(currentTemperatureLabel)
        addSubview(weatherLine1Label)
        addSubview(weatherLine2Label)
        addSubview(weatherLine3Label)
    }
    
    private func setConstraints() {
        weatherImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(262)
            $0.height.equalTo(262)
        }
        
        currentTemperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherImage.snp.top).offset(-25)
            $0.leading.equalToSuperview().inset(16)
        }
        
        weatherLine1Label.snp.makeConstraints {
            $0.top.equalTo(currentTemperatureLabel.snp.bottom).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        weatherLine2Label.snp.makeConstraints {
            $0.top.equalTo(weatherLine1Label.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        weatherLine3Label.snp.makeConstraints {
            $0.top.equalTo(weatherLine2Label.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-20) // 하단 여백 추가
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
