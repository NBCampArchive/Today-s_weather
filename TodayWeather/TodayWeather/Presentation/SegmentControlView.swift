//
//  SegmentControlView.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/17/24.
//

import UIKit
import SnapKit
import Then

class SegmentControlView: UIView {
    private let segmentTitles = ["AQI", "PM10", "PM2.5", "O3", "NO2", "CO", "SO2"]
    private var buttons: [UIButton] = []
    private var selectorView: UIView!
    private var selectedIndex: Int = 0 {
        didSet {
            updateButtonColors()
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            updateButtonColors()
        }
    }
    
    private let stackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    private func setupView() {
        self.do {
            $0.backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.91, alpha: 1.0)
            $0.layer.cornerRadius = self.frame.height / 2
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
            $0.layer.shadowRadius = 4
        }
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(3)
        }
        setupButtons()
    }
    
    private func setupButtons() {
        segmentTitles.enumerated().forEach { index, title in
            let button = UIButton(type: .system).then {
                $0.setTitle(title, for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.backgroundColor = (index == selectedIndex) ? selectedColor : .clear
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                $0.titleLabel?.adjustsFontSizeToFitWidth = true
                $0.titleLabel?.minimumScaleFactor = 0.5
                $0.titleLabel?.numberOfLines = 1
                $0.titleLabel?.lineBreakMode = .byTruncatingTail
                $0.layer.cornerRadius = 15
                $0.tag = index
                $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            }
            
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        print("Selected Index: \(selectedIndex)")
        updateButtonColors()
    }
    
    private func updateButtonColors() {
        buttons.enumerated().forEach { index, button in
            button.backgroundColor = (index == selectedIndex) ? selectedColor : .clear
        }
    }
}

