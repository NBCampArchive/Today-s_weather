//
//  WeatherViewController.swift
//  TodayWeather
//
//  Created by 예슬 on 5/15/24.
//

import SnapKit
import Then
import UIKit

class WeatherViewController: UIViewController {
    
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
    
    var weatherData: CurrentResponseModel? {
        didSet {
            configureLocation()
        }
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentsView = UIView()
    
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private lazy var dateLable = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.text = configureDate()
    }
    
    private let locationMarkImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "star")
    }
    
    private let cityLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 32, weight: .bold)
    }
    
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    private let weatherStateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 96)
        $0.text = "Sunny"
        $0.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
    
    private lazy var weatherImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "star")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LocationManager.shared.requestLocation { location in
            guard let location = location else { return }
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            
            print("Latitude: \(self.latitude)")
            print("Longitude: \(self.longitude)")
        }
        
    }
    // MARK: - API 관련 함수
    // 금일 날씨 API 호출
    private func callAPIs(){
        WeatherAPIManager.shared.getCurrentWeatherData(latitude: self.latitude, longitude: self.longitude) { result in
            switch result {
                case .success(let data):
                    self.weatherData = data
                    print("GetCurrentWeatherData Success : \(data)")
                case .failure(let error):
                    print("GetCurrentWeatherData Failure \(error)")
            }
        }
    }
    // MARK: - UI 관련 함수
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        
        [verticalStackView,
         weatherStateLabel,
         weatherImage].forEach {
            contentsView.addSubview($0)
        }
        
        [dateLable,
         horizontalStackView].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
        [locationMarkImage,
         cityLabel,
         countryLabel].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
        
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.edges.equalTo(self.contentsView)
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.leading.equalToSuperview().inset(20)
        }
        
        weatherStateLabel.snp.makeConstraints {
            $0.top.equalTo(contentsView.snp.top).inset(124)
            $0.trailing.equalToSuperview().inset(-50)
        }
        
        weatherImage.snp.makeConstraints {
            $0.top.equalTo(verticalStackView.snp.bottom).inset(-120)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(262)
        }
    }
    
    private func configureLocation() {
        self.cityLabel.text = weatherData?.name
        self.countryLabel.text = countryName(countryCode: weatherData?.sys.country ?? "")
    }
    
    private func configureDate() -> String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "eeee MMMM d"
        let dateString = dateFormatter.string(from: nowDate)
        
        return dateString
    }
    
    private func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        if countryCode == "KR" {
            return "Korea"
        }
        return current.localizedString(forRegionCode: countryCode)
    }
    
}

#Preview {
    WeatherViewController()
}
