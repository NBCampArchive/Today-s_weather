//
//  FashionModel.swift
//  TodayWeather
//
//  Created by t2023-m0074 on 5/23/24.
//

import Foundation

enum Fashion {
    case spring // 17도 ~ 22도 이하
    case summer // 23도 ~ 28도 이상
    case autumn // 9도 ~ 16도 이하
    case winter // 8도 이하
    
    init(temp: Int) {
        switch temp {
        case 17...22:
            self = .spring
        case 23...28:
            self = .summer
        case 9...16:
            self = .autumn
        case 8...4:
            self = .winter
        default:
            self = .summer
        }
    }
    
    func recommendClothes() -> [String] {
        switch self {
        case .spring:
            return ["맨투맨", "후드" ,"슬랙스" ,"얇은가디건"]
        case .summer:
            return ["민소매", "반팔" ,"얇은셔츠" ,"반바지"]
        case .autumn:
            return ["자켓", "트랜치코트", "점퍼", "니트"]
        case .winter:
            return ["패딩", "기모", "두꺼운코트", "목도리"]
        }
    }
}
