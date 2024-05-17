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
    
   static let identifier = "FashionTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    func configureUI() {
        contentView.addSubview(boxView)
        boxView.addSubview(tmpLabel)
        boxView.addSubview(subLabel)
        boxView.addSubview(fashionLabel)
        

        
        boxView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(20)
        }
        tmpLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        subLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(tmpLabel.snp.bottom).offset(12)
        }
        fashionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
