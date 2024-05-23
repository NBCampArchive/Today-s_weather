//
//  FoodViewController.swift
//  TodayWeather
//

import Alamofire
import Combine
import SnapKit
import Then
import UIKit

class FoodViewController: UIViewController {
    
    // Combine 관련 프로퍼티
    var cancellable = Set<AnyCancellable>()
    
    // UI 요소들
    let foodLocationView = FoodLocationView()
    let foodWeatherView = FoodWeatherView()
    let foodSuggestionsView = FoodSuggestionsView()
    
    let scrollView = UIScrollView().then{
        $0.showsVerticalScrollIndicator = false
    }
    let containerView = UIView()
    
    var weatherData: CurrentResponseModel?
    
    // View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "fewCloudyBackground")
        
        foodLocationView.dateLabel.text = configureDate()
        configureUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        WeatherDataManager.shared.$weatherData
            .sink { [weak self] weatherData in
                guard let weatherData = weatherData else { return }
                CurrentWeather.id = weatherData.weather[0].id
                self?.view.backgroundColor = CurrentWeather.shared.weatherColor()
                CurrentWeather.shared.reverseGeocode(latitude: weatherData.coord.lat, longitude: weatherData.coord.lon, save: false) { data in
                    switch data {
                    case .success(let name) :
                        self?.foodLocationView.cityLabel.text = name[0]
                        self?.foodLocationView.countryLabel.text = self?.countryName(countryCode: weatherData.sys.country)
                        self?.foodWeatherView.weatherImage.snp.remakeConstraints{
                            $0.top.equalToSuperview().offset(180)
                            $0.leading.equalToSuperview().inset(10)
                            $0.width.equalTo(262)
                            $0.height.equalTo(262)
                        }
                        self?.updateUI(with: weatherData)
                    case .failure(let error) :
                        print("Reverse geocoding error: \(error.localizedDescription)")
                    }
                    
                }
            }
            .store(in: &cancellable)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        foodWeatherView.weatherImage.snp.remakeConstraints{
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().inset(10)
            $0.width.equalTo(262)
            $0.height.equalTo(262)
        }
    }
    
    // JSON 데이터 로드 함수
    private func loadWeatherRecommendations() -> WeatherRecommendations? {
        guard let url = Bundle.main.url(forResource: "weatherRecommendations", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherRecommendations.self, from: data)
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
    
    // UI 업데이트 함수
    private func updateUI(with weather: CurrentResponseModel) {
        guard let weatherCondition = weather.weather.first else { return }
        let weatherState = WeatherModel(id: weatherCondition.id)
        let temp = Int(weather.main.temp)
        let recommendations = loadWeatherRecommendations()
        
        let weatherDescription: String
        
        switch weatherState {
        case .sunny:
            weatherDescription = "더운 날씨"
            updateWeatherUI(backgroundColor: .sunnyBackground, imageName: "largeSunny", temperature: temp, weatherState: weatherState)
            updateFoodRecommendations(for: "sunny", with: recommendations)
            foodWeatherView.weatherLine1Label.textColor = .black.withAlphaComponent(0.4)
            foodWeatherView.weatherLine2Label.textColor = .black.withAlphaComponent(0.4)
            foodWeatherView.weatherLine3Label.textColor = .black.withAlphaComponent(0.4)
            
        case .rainy:
            weatherDescription = "비오는 날씨"
            updateWeatherUI(backgroundColor: .rainyBackground, imageName: "largeRainy", temperature: temp, weatherState: weatherState)
            updateFoodRecommendations(for: "rainy", with: recommendations)
        case .cloudy:
            weatherDescription = "추운 날씨"
            updateWeatherUI(backgroundColor: .cloudyBackground, imageName: "largeCloudy", temperature: temp, weatherState: weatherState)
            updateFoodRecommendations(for: "cloudy", with: recommendations)
        case .fewCloudy:
            weatherDescription = "맑은 날씨"
            updateWeatherUI(backgroundColor: .fewCloudyBackground, imageName: "largeFewCloudy", temperature: temp, weatherState: weatherState)
            updateFoodRecommendations(for: "fewCloudy", with: recommendations)
        }
        
        foodWeatherView.weatherLine1Label.text = "\(weatherDescription), 맛있는 선택"
        foodWeatherView.weatherLine2Label.text = "현재기온 \(temp)°에 먹는 맛 여기서 찾기"
    }
    
    private func updateWeatherUI(backgroundColor: UIColor, imageName: String, temperature: Int, weatherState: WeatherModel) {
        DispatchQueue.main.async {
            // 배경색 변경
            UIView.animate(withDuration: 0.3) {
                self.view.backgroundColor = backgroundColor
            }
            
            // 이미지 변경
            self.foodWeatherView.weatherImage.image = UIImage(named: imageName)
            self.foodWeatherView.currentTemperatureLabel.text = "\(temperature)°"
            
            // 애니메이션으로 제약 조건 변경
            UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
                self.foodWeatherView.updateWeatherConstraints(
                    topOffset:
                        weatherState == .sunny ? 0 :
                        weatherState == .rainy ? 0 :
                        weatherState == .fewCloudy ? 0 : 0,
                    leadingOffset:
                        weatherState == .sunny ? 165 :
                        weatherState == .rainy ? 165 :
                        weatherState == .fewCloudy ? 180 : 160,
                    width:
                        weatherState == .sunny ? 288 :
                        weatherState == .rainy ? 252 :
                        weatherState == .fewCloudy ? 298 : 340,
                    height:
                        weatherState == .sunny ? 288 :
                        weatherState == .rainy ? 252 :
                        weatherState == .fewCloudy ? 298 : 340
                )
                // 레이아웃 업데이트
                self.view.layoutIfNeeded()
            }.startAnimation()
        }
    }
    
    
    private func updateFoodRecommendations(for weather: String, with recommendations: WeatherRecommendations?) {
        guard let recommendations = recommendations else { return
        }
        if let food = recommendations.weatherRecommendations[weather] {
            foodSuggestionsView.koreanMenuLabel.text = food.korean.joined(separator: ", ")
            foodSuggestionsView.westernMenuLabel.text = food.western.joined(separator: ", ")
            foodSuggestionsView.chineseMenuLabel.text = food.chinese.joined(separator: ", ")
            foodSuggestionsView.japaneseMenuLabel.text = food.japanese.joined(separator: ", ")
        }
    }
    
    // UI 구성 함수
    private func configureUI() {
        view.addSubview(scrollView)
        self.scrollView.addSubview(containerView)
        containerView.addSubview(foodLocationView)
        containerView.addSubview(foodWeatherView)
        containerView.addSubview(foodSuggestionsView)
        
    }
    
    // 제약 조건 설정 함수
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(880)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        foodLocationView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(78)
            $0.width.equalToSuperview().offset(20)
        }
        
        foodWeatherView.snp.makeConstraints {
            $0.top.equalTo(foodLocationView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(15)
        }
        
        foodSuggestionsView.snp.makeConstraints {
            $0.top.equalTo(foodWeatherView.weatherLine3Label.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(23).priority(.high)
        }
    }
}

// UIView 확장: 여러 서브뷰 추가
extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
        }
    }
}

// UIStackView 확장: 여러 서브뷰 추가
extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addArrangedSubview($0)
        }
    }
}
