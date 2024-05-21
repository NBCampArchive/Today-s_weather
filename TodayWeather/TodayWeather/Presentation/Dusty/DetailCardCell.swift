//
//  DetailCardCell.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/21/24.
//

import UIKit
import SnapKit
import Then

class DetailCardCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailCardCell"
    
    private let titleLabel = UILabel().then {
        $0.text = "PM 2.5"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "Unhealthy"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
    }
    
    private let valueLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.textColor = .black
    }
    
    private let circleView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.99, green: 0.76, blue: 0.76, alpha: 1.0)
        $0.layer.cornerRadius = 15
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(circleView)
        
        contentView.backgroundColor = .white.withAlphaComponent(0.4)
        contentView.layer.cornerRadius = 10
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(12)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(12)
        }
        
        valueLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.equalToSuperview().offset(12)
        }
        
        circleView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.width.height.equalTo(32)
        }
    }
    
    func configure(with iaqi: AQIValue, title: String) {
        print(iaqi)
        titleLabel.text = title
        valueLabel.text = "\(iaqi.v)"
    }
}


