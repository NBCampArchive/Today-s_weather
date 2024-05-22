//
//  SearchTableViewCell.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/16/24.
//

import UIKit
import Then
import SnapKit
protocol delDelegate {
    func delDelegate(row: Int)
}

class SearchTableViewCell: UITableViewCell {
    static let Identifier = "SearchTableViewCell"
    var delegate : delDelegate?
    var delRow = 0
    let locLbl = UILabel().then {
        $0.font = Pretendard.medium.of(size: 11)
        $0.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4030680877)
    }
    
    let cancelBtn = UIButton().then {
        $0.setImage(UIImage(named: "smallX"), for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.cancelBtn.addTarget(self, action: #selector(setBtnTap(_:)), for: .touchUpInside)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupLayout() {
        contentView.addSubview(locLbl)
        contentView.addSubview(cancelBtn)
        
        locLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8.5)
            $0.leading.equalToSuperview().offset(43)
            $0.trailing.equalToSuperview().offset(-32)
        }
        
        cancelBtn.snp.makeConstraints {
            $0.centerY.equalTo(locLbl.snp.centerY)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configureRecentUI(title : String, row : Int, count : Int){
        self.cancelBtn.isHidden = false
        self.locLbl.text = title
        self.locLbl.textColor = #colorLiteral(red: 0.3882352941, green: 0.3882352941, blue: 0.3882352941, alpha: 1)
        self.backgroundColor =  #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1).withAlphaComponent(0.8)
        self.selectionStyle = .none
        self.clipsToBounds = true
        if row == count {
            self.layer.cornerRadius = 16
            self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        }else {
            self.layer.cornerRadius = 0
        }
    }
    
    func configureResultUI(title : String, row : Int, count : Int, Recent : Bool) {
        self.cancelBtn.isHidden = true
        self.locLbl.text = title
        self.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.8)
        self.selectionStyle = .none
        self.clipsToBounds = true
        if Recent == true {
            if row == count{
                self.layer.cornerRadius = 16
                self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
            }else {
                self.layer.cornerRadius = 0
            }
        }else {
            self.layer.cornerRadius = 0
        }
    }
    
    @objc func setBtnTap(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.delDelegate(row: delRow)
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
        attributedText.addAttribute(.font, value: Pretendard.bold.of(size: 11), range: range)
        self.attributedText = attributedText
    }
}
