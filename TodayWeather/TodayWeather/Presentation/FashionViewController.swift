//
//  FashionViewController.swift
//  TodayWeather
//
//  Created by t2023-m0074 on 5/23/24.
//

import UIKit

class FashionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // JSON 데이터 로드 함수
    private func loadFashionRecommendations() -> FashionRecommendations? {
        guard let url = Bundle.main.url(forResource: "FashionRecommendations", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(FashionRecommendations.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    // 현재 날짜 설정 함수
    private func configureDate() -> String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "eeee MMMM d"
        return dateFormatter.string(from: nowDate)
    }
    
    // 국가 코드 변환 함수
    private func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
}
