//
//  UIViewExtension.swift
//  TodayWeather
//
//  Created by 예슬 on 5/17/24.
//

import UIKit

extension UIView {
    func gradientColor(bounds: CGRect, gradientLayer: CAGradientLayer) -> UIColor? {
        let renderer = UIGraphicsImageRenderer(size: gradientLayer.bounds.size)
        let image = renderer.image {context in
            gradientLayer.render(in: context.cgContext)
        }
        return UIColor(patternImage: image)
    }
}
