//
//  FashionTableViewCell.swift
//  TodayWeather
//
//  Created by t2023-m0074 on 5/16/24.
//

import UIKit

class FashionTableViewCell: UITableViewCell {

    let boxView = UIView()
    let tmpLabel = UILabel()
    let subLabel = UILabel()
    let fashionLabel = UILabel()
    let tmpFont = UIFont(name: "BagelFatOne-Regular", size: 40)
    let subFont = UIFont(name: "Gabarito-Medium", size: 14)
    let fashionFont = UIFont(name: "Pretendard-Regular", size: 13)
    
   static let identifier = "FashionTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        self.selectionStyle = .none
    }
    
    func configureUI() {
        self.backgroundColor = .clear
        tmpLabel.font = tmpFont
        subLabel.font = subFont
        fashionLabel.font = fashionFont
        boxView.layer.cornerRadius = 16
        self.boxView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.4)
        contentView.addSubview(boxView)
        boxView.addSubview(tmpLabel)
        boxView.addSubview(subLabel)
        boxView.addSubview(fashionLabel)
        

        
        boxView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(5)
        }
        tmpLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        subLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(tmpLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(16)
        }
        fashionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
