//
//  FoodSuggestionsView.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//
import UIKit
import SnapKit
import Then

// 음식 설명 레이블 및 제약조건
class FoodSuggestionsView: UIView {
    let suggestionsTitleLabel = UILabel().then {
        $0.text = "이런 음식은 어떠세요?"
        $0.font = Pretendard.medium.of(size: 12)
        $0.textColor = .black.withAlphaComponent(0.7)
    }
    
    let koreanFoodLabel = UILabel().then {
        $0.text = "한식"
        $0.font = Pretendard.bold.of(size: 16)
    }
    
    let koreanMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = Pretendard.regular.of(size: 14)
        $0.textColor = UIColor(named: "menu")
    }
    
    let koreanSeparator = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    let westernFoodLabel = UILabel().then {
        $0.text = "양식"
        $0.font = Pretendard.bold.of(size: 16)
    }
    
    let westernMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = Pretendard.regular.of(size: 14)
        $0.textColor = UIColor(named: "menu")
    }
    
    let westernSeparator = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    let chineseFoodLabel = UILabel().then {
        $0.text = "중식"
        $0.font = Pretendard.bold.of(size: 16)
    }
    
    let chineseMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = Pretendard.regular.of(size: 14)
        $0.textColor = UIColor(named: "menu")
    }
    
    let chineseSeparator = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    let japaneseFoodLabel = UILabel().then {
        $0.text = "일식"
        $0.font = Pretendard.bold.of(size: 16)
    }
    
    let japaneseMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = Pretendard.regular.of(size: 14)
        $0.textColor = UIColor(named: "menu")
    }
    
    let japaneseSeparator = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.8)
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
        self.addSubviews(suggestionsTitleLabel, koreanFoodLabel, koreanMenuLabel, koreanMenuLabel, koreanSeparator, westernFoodLabel, westernMenuLabel, westernSeparator, chineseFoodLabel, chineseMenuLabel, chineseSeparator, japaneseFoodLabel, japaneseMenuLabel, japaneseSeparator)
    }
    
    private func setConstraints() {
        suggestionsTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview()
        }
        
        koreanFoodLabel.snp.makeConstraints {
            $0.top.equalTo(suggestionsTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(1)
        }
        
        koreanMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(koreanFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        koreanSeparator.snp.makeConstraints {
            $0.top.equalTo(koreanFoodLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        westernFoodLabel.snp.makeConstraints {
            $0.top.equalTo(koreanSeparator.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        westernMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(westernFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        westernSeparator.snp.makeConstraints {
            $0.top.equalTo(westernFoodLabel.snp.bottom).offset(10)
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        chineseFoodLabel.snp.makeConstraints {
            $0.top.equalTo(westernSeparator.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        chineseMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(chineseFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        chineseSeparator.snp.makeConstraints {
            $0.top.equalTo(chineseFoodLabel.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
        
        japaneseFoodLabel.snp.makeConstraints {
            $0.top.equalTo(chineseSeparator.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
        }
        
        japaneseMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(japaneseFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        japaneseSeparator.snp.makeConstraints {
            $0.top.equalTo(japaneseFoodLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
}
