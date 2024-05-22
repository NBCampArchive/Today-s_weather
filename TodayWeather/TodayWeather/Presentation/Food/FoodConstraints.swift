//
//  FoodConstraints.swift
//  TodayWeather
//
//  Created by Developer_P on 5/22/24.
//
import SnapKit
import UIKit

// FoodViewController 제약조건
extension FoodViewController {
    func setConstraints() {
        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.edges.equalTo(contentsView)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        contentsView.snp.makeConstraints { $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        foodLocationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        foodWeatherView.snp.makeConstraints {
            $0.top.equalTo(foodLocationView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        foodSuggestionsView.snp.makeConstraints {
            $0.top.equalTo(foodWeatherView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-90)
        }
    }
}
