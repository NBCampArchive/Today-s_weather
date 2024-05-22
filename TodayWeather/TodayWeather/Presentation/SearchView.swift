//
//  SearchView.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/20/24.
//

import UIKit

class SearchView : UIView {
    let searchBar = UISearchBar()
    
    let border = CALayer()
    
    let width = CGFloat(2.0)
    let selectTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .clear
    }
    
    let searchTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Layout
    func setupLayout() {
        addSubview(selectTableView)
        searchTableView.separatorStyle = .none
        selectTableView.separatorStyle = .none
        selectTableView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    //searchbar 클릭시 layout
    func searchLayout() {
        visualEffectView.frame = self.frame
        addSubview(visualEffectView)
        addSubview(searchTableView)
        searchTableView.contentInset = .zero
        searchTableView.contentInsetAdjustmentBehavior = .never
        searchBar.layer.cornerRadius = 0 // 모서리를 직각으로 만듭니다.
        searchBar.layer.masksToBounds = true
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(-12)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // 서치바 layout 변경
    func searchChanging() {
        searchBar.setImage(UIImage(named: "searchSelected"), for: .search, state: .normal)
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 0
            textfield.layer.cornerRadius = 16
            textfield.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            border.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            border.frame = CGRect(x: 13, y: textfield.frame.size.height - 5, width:  textfield.frame.size.width-26, height: 1)
            border.borderWidth = width
            textfield.layer.addSublayer(border)
            textfield.layer.masksToBounds = true
        }
    }
    
    func searchEnd() {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 16
            textfield.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner)
            border.frame = CGRect(x: -5, y: textfield.frame.size.height, width:  textfield.frame.size.width+10, height: textfield.frame.size.height)
        }
    }
    
    func setupSearch() {
        searchBar.setImage(UIImage(named: "searchUnselected"), for: .search, state: .normal)
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.borderStyle = .none
            textfield.snp.makeConstraints {
                $0.top.equalToSuperview().offset(4)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(40)
            }
            if let clearButton = textfield.value(forKey: "clearButton") as? UIButton {
                clearButton.isHidden = true
                let customView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                
                // Create the button and add it to the custom view
                let customButton = UIButton(type: .custom)
                customButton.frame = customView.bounds
                customButton.setImage(UIImage(named: "largeX"), for: .normal)
                customButton.addTarget(self, action: #selector(clearView(_:)), for: .touchUpInside)
                customView.addSubview(customButton)
                
                // Set the custom view as the right view of the text field
                textfield.rightView = customView
                textfield.rightViewMode = .whileEditing
            }
            if let leftView = textfield.leftView {
                // 새로운 왼쪽 뷰에 패딩을 추가하는 빈 UIView를 생성하고 기존 leftView와 함께 스택뷰로 포함
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: leftView.frame.height))
                let stackView = UIStackView(arrangedSubviews: [leftView,paddingView])
                stackView.distribution = .fillProportionally
                stackView.axis = .horizontal
                textfield.leftView = stackView
                paddingView.snp.makeConstraints {
                    $0.width.equalTo(8)
                }
            }
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 16
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "어느지역 날씨가 궁금해요?", attributes: [NSAttributedString.Key.foregroundColor : UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), NSAttributedString.Key.font : Pretendard.medium.of(size: 11)])
            textfield.tintColor = UIColor(named: "yp-m")
            textfield.textColor = UIColor(named: "bk")
            textfield.font = Pretendard.bold.of(size: 11)
            textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
        }
    }
    @objc func clearView(_ sender: UIButton) {
        searchEnd()
        searchBar.setImage(UIImage(named: "searchUnselected"), for: .search, state: .normal)
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
        }
        searchBar.text = ""
        visualEffectView.removeFromSuperview()
        searchTableView.removeFromSuperview()
        searchBar.resignFirstResponder()
    }
}
