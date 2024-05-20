//
//  selectedTableViewCell.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/16/24.
//

import UIKit
import SnapKit
import Then

class SelectedTableViewCell: UITableViewCell {
    
    static let Identifier = "SelectedTableViewCell"
    let container = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.4)
        $0.layer.cornerRadius = 16
    }
    let tempLbl = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 40)
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    let locLbl = UILabel().then {
        $0.font = Gabarito.semibold.of(size: 14)
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    var weatherImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.4)
        contentView.layer.cornerRadius = 16
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 0))
    }
    func setupLayout() {
        contentView.addSubview(tempLbl)
        contentView.addSubview(locLbl)
        contentView.addSubview(weatherImage)
        
        tempLbl.snp.makeConstraints{
            $0.top.equalTo(self.contentView.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(self.contentView.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.bottom.equalTo(self.contentView.safeAreaLayoutGuide.snp.bottom).offset(-43)
        }
        
        locLbl.snp.makeConstraints {
            $0.top.equalTo(tempLbl.snp.bottom).offset(12)
            $0.leading.equalTo(self.contentView.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.bottom.equalTo(self.contentView.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
        weatherImage.snp.makeConstraints {
            $0.top.equalTo(self.contentView.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(-20)
            $0.height.width.equalTo(64)
        }
    }

}
