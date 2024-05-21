//
//  Fonts.swift
//  TodayWeather
//
//  Created by 예슬 on 5/16/24.
//

import UIKit

enum Gabarito: String {
    case bold = "Gabarito-Bold"
    case medium = "Gabarito-Medium"
    case regular = "Gabarito-Regular"
    case semibold = "Gabarito-SemiBold"
    
    // 사용 시 아래 예시와 같이 사용하면 됩니다. ViewController 파일에도 적어놨어요.
    // enum이름.굵기이름.of(size: 원하는 사이즈)
    // Gabarito.bold.of(size: 30)
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

enum Pretendard: String {
    case bold = "Pretendard-Bold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case semibold = "Pretendard-SemiBold"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

enum GlacialIndifference: String {
    case regular = "GlacialIndifference-Regular"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

enum BagelFatOne: String {
    case regular = "BagelFatOne-Regular"
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
