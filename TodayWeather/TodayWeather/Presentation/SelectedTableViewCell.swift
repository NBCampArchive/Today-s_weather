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
    
    let tempLbl = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 40)
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    let locLbl = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(tempLbl)
        addSubview(locLbl)
        
        tempLbl.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-43)
        }
        
        locLbl.snp.makeConstraints {
            $0.top.equalTo(tempLbl.snp.bottom).offset(12)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
    }

}
