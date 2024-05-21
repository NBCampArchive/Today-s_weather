//
//  SuggestionsView.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//
import UIKit
import Then

class SuggestionsView: UIView {
    
    let koreanMenuLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
    }
    
    let westernMenuLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
    }
    
    let chineseMenuLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
    }
    
    let japaneseMenuLabel = UILabel().then {
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
    }
    
    init() {
        super.init(frame: .zero)
        
        let koreanFoodLabel = UILabel().then {
            $0.font = UIFont(name: "Pretendard", size: 16)
            $0.text = "한식"
        }
        
        let westernFoodLabel = UILabel().then {
            $0.font = UIFont(name: "Pretendard", size: 16)
            $0.text = "양식"
        }
        
        let chineseFoodLabel = UILabel().then {
            $0.font = UIFont(name: "Pretendard", size: 16)
            $0.text = "중식"
        }
        
        let japaneseFoodLabel = UILabel().then {
            $0.font = UIFont(name: "Pretendard", size: 16)
            $0.text = "일식"
        }
        
        let koreanSeparator = UIView().then {
            $0.backgroundColor = .black
        }
        
        let westernSeparator = UIView().then {
            $0.backgroundColor = .black
        }
        
        let chineseSeparator = UIView().then {
            $0.backgroundColor = .black
        }
        
        let japaneseSeparator = UIView().then {
            $0.backgroundColor = .black
        }
        
        [koreanFoodLabel, koreanMenuLabel, koreanSeparator,
         westernFoodLabel, westernMenuLabel, westernSeparator,
         chineseFoodLabel, chineseMenuLabel, chineseSeparator,
         japaneseFoodLabel, japaneseMenuLabel, japaneseSeparator].forEach {
            addSubview($0)
        }
        
        // 제약 조건 설정
        koreanFoodLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview()
        }
        
        koreanMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(koreanFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        koreanSeparator.snp.makeConstraints {
            $0.top.equalTo(koreanFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        westernFoodLabel.snp.makeConstraints {
            $0.top.equalTo(koreanSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        westernMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(westernFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        westernSeparator.snp.makeConstraints {
            $0.top.equalTo(westernFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        chineseFoodLabel.snp.makeConstraints {
            $0.top.equalTo(westernSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        chineseMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(chineseFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        chineseSeparator.snp.makeConstraints {
            $0.top.equalTo(chineseFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        japaneseFoodLabel.snp.makeConstraints {
            $0.top.equalTo(chineseSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        japaneseMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(japaneseFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        japaneseSeparator.snp.makeConstraints {
            $0.top.equalTo(japaneseFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
