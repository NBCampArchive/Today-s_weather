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
          //  callAPIs()
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
    
    // 날짜와 위치 정보
    private let weatherAndLocationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    // 위치 정보(locationMark + 위치 레이블)
    private let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private let locationLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .firstBaseline
    }
    
    private lazy var dateLable = UILabel().then {
        $0.font = Gabarito.bold.of(size: 17)
        $0.text = configureDate()
    }
    
    private let locationMarkImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "locationMark")
    }
    
    private let cityLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 32)
        $0.text = "Seoul"
    }
    
    private let countryLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 15)
        $0.text = "Korea"
    }
    
    private let weatherStateLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 96)
        $0.text = "Sunny"
        $0.textColor = .sunnyText
        $0.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
    
    private lazy var weatherImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "sunny")
    }
    
    private let currentTemperatureLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 96)
        $0.text = "20°"
    }
    
    private let maximumTemperatureLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 42)
        $0.text = "22°"
        $0.textColor = .black30
    }
    
    private let minimumTemperatureLabel = GradientLabel().then {
        $0.font = BagelFatOne.regular.of(size: 42)
        $0.text = "22°"
    }
    
    private let maxMinTempStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
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
                    DispatchQueue.main.async {
                        self.updateUI(with: data)
                    }
                    print("GetCurrentWeatherData Success : \(data)")
                case .failure(let error):
                    print("GetCurrentWeatherData Failure \(error)")
            }
        }
    }
    // MARK: - UI 관련 함수
    private func configureUI() {
        view.backgroundColor = .rainyBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        
        [weatherAndLocationStackView,
         weatherImage,
         weatherStateLabel,
         currentTemperatureLabel,
         maxMinTempStackView
         ].forEach {
            contentsView.addSubview($0)
        }
        
        [dateLable,
         locationStackView].forEach {
            weatherAndLocationStackView.addArrangedSubview($0)
        }
        
        [locationMarkImage,
         locationLabelStackView].forEach {
            locationStackView.addArrangedSubview($0)
        }
        
        [cityLabel,
         countryLabel].forEach {
            locationLabelStackView.addArrangedSubview($0)
        }
        
        [maximumTemperatureLabel, 
         minimumTemperatureLabel].forEach {
            maxMinTempStackView.addArrangedSubview($0)
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
        
        weatherAndLocationStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.leading.equalToSuperview().inset(20)
        }
        
        weatherStateLabel.snp.makeConstraints {
            $0.top.equalTo(contentsView.snp.top).inset(124)
            $0.trailing.equalToSuperview().inset(-80)
        }
        
        weatherImage.snp.makeConstraints {
            $0.top.equalTo(weatherAndLocationStackView.snp.bottom).inset(-120)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(262)
        }
        
        currentTemperatureLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(44)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(194)
        }
        
        maxMinTempStackView.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(130)
            $0.trailing.equalToSuperview().inset(24)
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
    
    func updateUI(with weather: CurrentResponseModel) {
        guard let weatherCondition = weather.weather.first else { return }
        let weatherState = WeatherModel(id: weatherCondition.id)
        
        // Update weather label
        // weatherStateLabel.text = weatherCondition.main.capitalized
        
        // Update weather image
        
        
        // Update background color and layout based on weather ID
        switch weatherState {
            case .sunny:
                self.view.backgroundColor = .sunnyBackground
                //remakeConstraintsForClearSky()
            case .rainy:
                self.view.backgroundColor = .rainyBackground
                //remakeConstraintsForRain()
            case .cloudy:
                self.view.backgroundColor = .cloudyBackground
                //remakeConstraintsForCloudy()
            case .fewCloudy:
                self.view.backgroundColor = .fewCloudytext
        }
    }
}
