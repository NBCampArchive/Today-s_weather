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
        $0.font = UIFont(name: "Pretendard", size: 12)
    }
    
    let koreanFoodLabel = UILabel().then {
        $0.text = "한식"
        $0.font = UIFont(name: "Pretendard", size: 16)
    }
    
    let koreanMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
    }
    
    let koreanSeparator = UIView().then {
        $0.backgroundColor = .black
    }
    
    let westernFoodLabel = UILabel().then {
        $0.text = "양식"
        $0.font = UIFont(name: "Pretendard", size: 16)
    }
    
    let westernMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
    }
    
    let westernSeparator = UIView().then {
        $0.backgroundColor = .black
    }
    
    let chineseFoodLabel = UILabel().then {
        $0.text = "중식"
        $0.font = UIFont(name: "Pretendard", size: 16)
    }
    
    let chineseMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
    }
    
    let chineseSeparator = UIView().then {
        $0.backgroundColor = .black
    }
    
    let japaneseFoodLabel = UILabel().then {
        $0.text = "일식"
        $0.font = UIFont(name: "Pretendard", size: 16)
    }
    
    let japaneseMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
    }
    
    let japaneseSeparator = UIView().then {
        $0.backgroundColor = .black
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
        addSubview(suggestionsTitleLabel)
        addSubview(koreanFoodLabel)
        addSubview(koreanMenuLabel)
        addSubview(koreanSeparator)
        addSubview(westernFoodLabel)
        addSubview(westernMenuLabel)
        addSubview(westernSeparator)
        addSubview(chineseFoodLabel)
        addSubview(chineseMenuLabel)
        addSubview(chineseSeparator)
        addSubview(japaneseFoodLabel)
        addSubview(japaneseMenuLabel)
        addSubview(japaneseSeparator)
    }
    
    private func setConstraints() {
        suggestionsTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        koreanFoodLabel.snp.makeConstraints {
            $0.top.equalTo(suggestionsTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        koreanMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(koreanFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        koreanSeparator.snp.makeConstraints {
            $0.top.equalTo(koreanFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(1)
        }
        
        westernFoodLabel.snp.makeConstraints {
            $0.top.equalTo(koreanSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        westernMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(westernFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        westernSeparator.snp.makeConstraints {
            $0.top.equalTo(westernFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(1)
        }
        
        chineseFoodLabel.snp.makeConstraints {
            $0.top.equalTo(westernSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        chineseMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(chineseFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        chineseSeparator.snp.makeConstraints {
            $0.top.equalTo(chineseFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(1)
        }
        
        japaneseFoodLabel.snp.makeConstraints {
            $0.top.equalTo(chineseSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        japaneseMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(japaneseFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        japaneseSeparator.snp.makeConstraints {
            $0.top.equalTo(japaneseFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
