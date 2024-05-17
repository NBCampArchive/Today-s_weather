//
//  GradientLabel.swift
//  TodayWeather
//
//  Created by 예슬 on 5/17/24.
//

import UIKit

final class GradientLabel: UILabel {
    private var colors: [UIColor] = [.black30, .white]
    private var startPoint: CGPoint = CGPoint(x: 0.0, y: -0.5)
    private var endPoint: CGPoint = CGPoint(x: 0.0, y: 0.9)
    private var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyColors()
    }
    
    func update(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        applyColors()
    }
    
    private func setup() {
        isAccessibilityElement = true
        applyColors()
    }
    
    private func applyColors() {
        let gradient = getGradientLayer(bounds: self.bounds)
        textColor = gradientColor(bounds: self.bounds, gradientLayer: gradient)
    }
    
    private func getGradientLayer(bounds: CGRect) -> CAGradientLayer {
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        return gradientLayer
    }
}

