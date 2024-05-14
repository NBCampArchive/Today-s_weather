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
    let dotCount = 10
    
    let aqiLabel = UILabel().then{
        $0.text = "127"
        $0.font = .systemFont(ofSize: 96, weight: .regular)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor =  UIColor(named: "dustFineColor")
        createDots()
        animateDots()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createDots()
        animateDots()
    }
    
    func setupLayout() {
        self.addSubview(aqiLabel)
        aqiLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
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
    
    func animateDots() {
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
}
