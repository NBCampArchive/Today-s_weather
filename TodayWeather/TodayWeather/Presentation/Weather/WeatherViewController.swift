//
//  WeatherViewController.swift
//  TodayWeather
//
//  Created by 예슬 on 5/15/24.
//

import Combine
import SnapKit
import Then
import UIKit

class WeatherViewController: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    
    var longitude: Double = 0 {
        didSet {
            callAPIs()
        }
    }
    
    var latitude: Double = 0
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentsView = UIView()
    
    // 날짜와 위치 정보 StackView
    private let weatherAndLocationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    // 위치 정보(locationMark + 위치 레이블) StackView
    private let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    // 위치 레이블(도시, 나라) StackView
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
    
    private lazy var cityLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 32)
        $0.text = WeatherDataManager.shared.weatherData?.name ?? "Cupertino"
    }
    
    private lazy var countryLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 15)
        $0.text = WeatherDataManager.shared.weatherData?.sys.country ?? "United States"
    }
    
    private lazy var weatherStateLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 96)
        $0.text = "Sunny"
        $0.textColor = .sunnyText
        $0.transform = CGAffineTransform(rotationAngle: .pi / 2)
    }
    
    private lazy var weatherImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "largeSunny")
    }
    
    private lazy var currentTemperatureLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 96)
        $0.text = String(Int(WeatherDataManager.shared.weatherData?.main.temp ?? 0)) + "°"
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.requestLocation { [weak self] location in
            guard let location = location else { return }
            self?.latitude = location.coordinate.latitude
            self?.longitude = location.coordinate.longitude
            
            print("Latitude: \(self?.latitude ?? 0)")
            print("Longitude: \(self?.longitude ?? 0)")
        }
        configureUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WeatherDataManager.shared.$weatherData
            .sink { [weak self] weatherData in
                guard let weatherData = weatherData else { return }
                self?.updateUI(with: weatherData)
            }
            .store(in: &cancellable)
    }
    // MARK: - API 관련 함수
    // 금일 날씨 API 호출
    private func callAPIs(){
        WeatherAPIManager.shared.getCurrentWeatherData(latitude: self.latitude, longitude: self.longitude)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("GetCurrentWeatherData Failure: \(error)")
                }
            }, receiveValue: { data in
                WeatherDataManager.shared.weatherData = data
                self.updateUI(with: data)
                print("GetCurrentWeatherData Success: \(data)")
            })
            .store(in: &cancellable)
    }
    // MARK: - UI 관련 함수
    private func configureUI() {
        view.backgroundColor = .sunnyBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        
        [weatherAndLocationStackView,
         weatherImage,
         weatherStateLabel,
         currentTemperatureLabel
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
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.edges.equalTo(self.contentsView)
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        weatherAndLocationStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(94)
            $0.leading.equalToSuperview().inset(20)
        }
        // Sunny label
        weatherStateLabel.snp.makeConstraints {
            $0.top.equalTo(contentsView.snp.top).inset(164)
            $0.trailing.equalToSuperview().inset(-80)
        }
        // Sunny image
        weatherImage.snp.makeConstraints {
            $0.top.equalTo(weatherAndLocationStackView.snp.bottom).inset(-120)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(262)
            $0.height.equalTo(262)
        }
        
        currentTemperatureLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(44)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(105)
        }
    }
    
    func configureDate() -> String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "eeee MMMM d"
        let dateString = dateFormatter.string(from: nowDate)
        
        return dateString
    }
    
    func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
    
    private func updateUI(with weather: CurrentResponseModel) {
        guard let weatherCondition = weather.weather.first else { return }
        let weatherState = WeatherModel(id: weatherCondition.id)
        
        self.currentTemperatureLabel.text = String(Int(WeatherDataManager.shared.weatherData?.main.temp ?? 0)) + "°"
        self.cityLabel.text = WeatherDataManager.shared.weatherData?.name
        self.countryLabel.text = countryName(countryCode: WeatherDataManager.shared.weatherData?.sys.country ?? "")
        
        switch weatherState {
            case .sunny:
                updateSunny()
            case .rainy:
                updateRainy()
            case .cloudy:
                updateCloudy()
            case .fewCloudy:
                updateFewCloudy()
        }
    }
    
    private func updateSunny() {
        self.view.backgroundColor = .sunnyBackground
        self.weatherStateLabel.text = "Sunny"
        self.weatherStateLabel.textColor = .sunnyText
        self.weatherImage.image = UIImage(named: "largeSunny")
        self.weatherStateLabel.snp.updateConstraints {
            $0.top.equalTo(contentsView.snp.top).inset(164)
            $0.trailing.equalToSuperview().inset(-80)
        }
        self.weatherImage.snp.updateConstraints {
            $0.top.equalTo(weatherAndLocationStackView.snp.bottom).inset(-120)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(262)
            $0.height.equalTo(262)
        }
    }
    
    private func updateRainy() {
        self.view.backgroundColor = .rainyBackground
        self.weatherStateLabel.text = "Rainy"
        self.weatherStateLabel.textColor = .rainyText
        self.weatherImage.image = UIImage(named: "largeRainy")
        self.weatherStateLabel.snp.updateConstraints {
            $0.top.equalTo(contentsView.snp.top).inset(145)
            $0.trailing.equalToSuperview().inset(-60)
        }
        self.weatherImage.snp.updateConstraints {
            $0.top.equalTo(weatherAndLocationStackView.snp.bottom).inset(-130)
            $0.leading.equalToSuperview().inset(10)
            $0.width.equalTo(252)
            $0.height.equalTo(252)
        }
    }
    
    private func updateFewCloudy() {
        self.view.backgroundColor = .fewCloudyBackground
        self.weatherStateLabel.text = "Cloudy"
        self.weatherStateLabel.textColor = .fewCloudytext
        self.weatherImage.image = UIImage(named: "largeFewCloudy")
        self.weatherStateLabel.snp.updateConstraints {
            $0.top.equalTo(contentsView.snp.top).inset(170)
            $0.trailing.equalToSuperview().inset(-90)
        }
        self.weatherImage.snp.updateConstraints {
            $0.top.equalTo(weatherAndLocationStackView.snp.bottom).inset(-110)
            $0.leading.equalToSuperview().inset(15)
            $0.width.equalTo(357)
            $0.height.equalTo(298)
        }
    }
    
    private func updateCloudy() {
        self.view.backgroundColor = .cloudyBackground
        self.weatherStateLabel.text = "Cloudy"
        self.weatherStateLabel.textColor = .white
        self.weatherImage.image = UIImage(named: "largeCloudy")
        self.weatherStateLabel.snp.updateConstraints {
            $0.top.equalTo(contentsView.snp.top).inset(170)
            $0.trailing.equalToSuperview().inset(-90)
        }
        self.weatherImage.snp.updateConstraints {
            $0.top.equalTo(weatherAndLocationStackView.snp.bottom).inset(-105)
            $0.leading.equalToSuperview().inset(-64)
            $0.width.equalTo(340)
            $0.height.equalTo(340)
        }
    }
}
