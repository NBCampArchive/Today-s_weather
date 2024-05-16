//
//  SearchTableViewCell.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/16/24.
//

import UIKit
import Then
import SnapKit

class SearchTableViewCell: UITableViewCell {
    static let Identifier = "SearchTableViewCell"
    
    let locLbl = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4030680877)
    }
    
    let cancelBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "cancel"), for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(locLbl)
        addSubview(cancelBtn)
        
        locLbl.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().offset(32)
        }
        
        cancelBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(locLbl.snp.trailing).offset(8)
        }
    }
}

extension UILabel {
    func setHighlighted(_ text: String, with searchQuery: String) {
        guard let range = (self.text as NSString?)?.range(of: searchQuery, options: .caseInsensitive) else {
            return
        }

        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 11), range: range)
        self.attributedText = attributedText
    }
}
