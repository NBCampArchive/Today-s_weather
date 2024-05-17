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
    let weatherImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // 선택된 상태일 때의 애니메이션 정의
            if selected {
                UIView.animate(withDuration: 0.3, animations: {
                    self.contentView.backgroundColor = .clear.withAlphaComponent(0)
                    
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.contentView.backgroundColor = UIColor.clear
                })
            }
        }
    
    func setupLayout() {
        addSubview(container)
        container.addSubview(tempLbl)
        container.addSubview(locLbl)
        container.addSubview(weatherImage)
        container.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        tempLbl.snp.makeConstraints{
            $0.top.equalTo(container.snp.top).offset(16)
            $0.leading.equalTo(container.snp.leading).offset(20)
            $0.bottom.equalTo(container.snp.bottom).offset(-43)
        }
        
        locLbl.snp.makeConstraints {
            $0.top.equalTo(tempLbl.snp.bottom).offset(12)
            $0.leading.equalTo(container.snp.leading).offset(20)
            $0.bottom.equalTo(container.snp.bottom).offset(-16)
        }
        
        weatherImage.snp.makeConstraints {
            $0.top.equalTo(container.snp.top).offset(16)
            $0.trailing.equalTo(-20)
            $0.height.width.equalTo(64)
        }
    }

}
