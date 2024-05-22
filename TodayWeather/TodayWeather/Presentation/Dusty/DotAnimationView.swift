//
//  DustyBackgroundView.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/14/24.
//

import UIKit
import SnapKit
import Then

class DotAnimationView: UIView {
    var dots: [CALayer] = []
    
    let dotColor = UIColor.white.cgColor.copy(alpha: 0.5)
    var dotCount = 10 {
        didSet {
            updateDots()
        }
    }
    
    let aqiValueLabel = UILabel().then {
        $0.text = "127"
        $0.font = BagelFatOne.regular.of(size: 96)
        $0.textColor = .black
    }
    
    let aqiOptionLabel = UILabel().then {
        $0.text = "AQI"
        $0.font = Gabarito.medium.of(size: 14)
        $0.textColor = .black
    }
    
    let aqiQualityLabel = UILabel().then {
        $0.text = "Good"
        $0.font = BagelFatOne.regular.of(size: 17)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        createDots()
        startAnimatingDots()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createDots()
        startAnimatingDots()
    }
    
    func setupLayout() {
        self.addSubview(aqiValueLabel)
        self.addSubview(aqiOptionLabel)
        self.addSubview(aqiQualityLabel)
        
        aqiValueLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        aqiOptionLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(aqiValueLabel.snp.bottom).offset(4)
        }
        
        aqiQualityLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(aqiOptionLabel.snp.bottom)
        }
    }
    
    func createDots() {
        for _ in 0..<dotCount {
            let dotLayer = CALayer()
            let dotSize = CGFloat(Int.random(in: 5...15))
            dotLayer.frame.size = CGSize(width: dotSize, height: dotSize)
            dotLayer.backgroundColor = dotColor
            dotLayer.cornerRadius = dotSize / 2
            dotLayer.position = CGPoint(x: CGFloat.random(in: 0...300),
                                        y: CGFloat.random(in: 0...300))
            self.layer.addSublayer(dotLayer)
            dots.append(dotLayer)
        }
    }
    
    func startAnimatingDots() {
        for dot in dots {
            let duration = Double.random(in: 1...3)
            let delay = Double.random(in: 0...1)
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = dot.position
            animation.toValue = CGPoint(x: CGFloat.random(in: 0...300),
                                        y: CGFloat.random(in: 0...300))
            animation.duration = duration
            animation.beginTime = CACurrentMediaTime() + delay
            animation.repeatCount = Float.infinity
            animation.autoreverses = true
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            dot.add(animation, forKey: "position")
        }
    }
    
    func stopAnimatingDots() {
        for dot in dots {
            dot.removeAnimation(forKey: "position")
            dot.removeFromSuperlayer()
        }
        dots.removeAll()
    }
    
    func updateDots() {
        stopAnimatingDots()
        createDots()
        startAnimatingDots()
    }
}
