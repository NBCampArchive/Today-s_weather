//
//  ViewController.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/13/24.
//

import UIKit
import Then
import SnapKit

// ⚠️ 폴더 삭제 방지용 뷰컨트롤러 파일입니다.
// 개인작업은 각 폴더 생성 후 진행해주세요.(Model, Network 동일!)
// !!!!!!!!!! API KEY는 Resource/TodayWeatherAPIKey.plist 에 추가하고 사용해주세요 (해당 파일 커밋 금지) !!!!!!!!!!!!!
class ViewController: UIViewController {
    
    var longitude: Double = 0 {
        didSet {
            callAPIs()
        }
    }
    
    var latitude: Double = 0 {
        didSet {
            callAPIs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "sunnyBackground")
        // MARK: - 위치정보 권한 요청
        LocationManager.shared.requestLocation { location in
            guard let location = location else { return }
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            
            print("Latitude: \(self.latitude)")
            print("Longitude: \(self.longitude)")
        }
    }

    func callAPIs(){
        // MARK: - 금일 날씨 API 호출
        WeatherAPIManager.shared.getCurrentWeatherData(latitude: self.latitude, longitude: self.longitude) { result in
            switch result{
            case .success(let data):
                print("GetCurrentWeatherData Success : \(data)")
            case .failure(let error):
                print("GetCurrentWeatherData Failure \(error)")
            }
        }
        
        // MARK: - 주간 날씨 API 호출
        WeatherAPIManager.shared.getForecastWeatherData(latitude: self.latitude, longitude: self.longitude) { result in
            switch result{
            case .success(let data):
                print("getForecastWeatherData Success : \(data)")
            case .failure(let error):
                print("getForecastWeatherData Failure \(error)")
            }
        }
        
        // MARK: - 미세먼지 API 호출
        DustAPIManager.shared.getDustData(latitude: self.latitude, longitude: self.longitude) { result in
            switch result{
            case .success(let data):
                print("getDustData Success : \(data)")
            case .failure(let error):
                print("getDustData Failure \(error)")
            }
        }
    }
    
}

