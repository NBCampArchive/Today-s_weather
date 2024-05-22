import Alamofire
import Combine
import SnapKit
import Then
import UIKit

class FoodViewController: UIViewController {
    
    // Combine 관련 프로퍼티
    internal var cancellable = Set<AnyCancellable>()
    
    // 위치 정보
    var longitude: Double = 0 {
        didSet {
            callAPIs()
        }
    }
    
    var latitude: Double = 0
    
    // 날씨 데이터
    var weatherData: CurrentResponseModel? {
        didSet {
            configureLabel()
        }
    }
    
    // UI 요소들
    internal let scrollView = UIScrollView().then { $0.showsVerticalScrollIndicator = false }
    internal let contentsView = UIView()
    
    internal let weatherAndLocationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    internal let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    internal let locationLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .firstBaseline
    }
    
    internal lazy var dateLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 17)
        $0.text = configureDate()
    }
    
    internal let locationMarkImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "locationMark")
    }
    
    internal lazy var cityLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 32)
        $0.text = weatherData?.name ?? "Cupertino"
    }
    
    internal lazy var countryLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 15)
        $0.text = weatherData?.sys.country ?? "United States"
    }
    
    internal let foodWeatherView = FoodWeatherView()
    internal let foodSuggestionsView = FoodSuggestionsView()

    // View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "fewCloudyBackground")
        
        configureUI()
        setConstraints() // 제약 조건 설정
        
        callAPIs()
        
        LocationManager.shared.requestLocation { [weak self] location in
            guard let location = location else { return }
            self?.latitude = location.coordinate.latitude
            self?.longitude = location.coordinate.longitude
            print("Latitude: \(self?.latitude ?? 0)")
            print("Longitude: \(self?.longitude ?? 0)")
        }
    }
    
    // API 호출 함수
    private func callAPIs() {
        print("Calling APIs with latitude: \(self.latitude) and longitude: \(self.longitude)")
        WeatherAPIManager.shared.getCurrentWeatherData(latitude: self.latitude, longitude: self.longitude)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("API call finished")
                case .failure(let error):
                    print("GetCurrentWeatherData Failure: \(error)")
                    if let afError = error as? AFError, case .responseSerializationFailed(let reason) = afError {
                        switch reason {
                        case .decodingFailed(let decodingError):
                            print("Decoding error: \(decodingError)")
                            if let data = afError.underlyingError as? Data, let json = String(data: data, encoding: .utf8) {
                                print("Received data: \(json)")
                            }
                        default:
                            print("Other serialization error")
                        }
                    }
                }
            }, receiveValue: { data in
                print("Received data: \(data)")
                self.weatherData = data
                self.updateUI(with: data)
                print("GetCurrentWeatherData Success: \(data)")
            })
            .store(in: &cancellable)
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
    
    // UI 구성 함수
    private func configureUI() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentsView)
        contentsView.addSubviews(
            weatherAndLocationStackView, foodWeatherView, foodSuggestionsView
        )
        
        weatherAndLocationStackView.addArrangedSubviews(dateLabel, locationStackView)
        locationStackView.addArrangedSubviews(locationMarkImage, locationLabelStackView)
        locationLabelStackView.addArrangedSubviews(cityLabel, countryLabel)
    }
    
    // 라벨 설정 함수
    private func configureLabel() {
        self.cityLabel.text = weatherData?.name
        self.countryLabel.text = countryName(countryCode: weatherData?.sys.country ?? "")
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
            weatherDescription = "맑은 날씨"
            updateWeatherUI(backgroundColor: .sunnyBackground, imageName: "largeSunny", temperature: temp, weatherState: weatherState)
            updateFoodRecommendations(for: "sunny", with: recommendations)
        case .rainy:
            weatherDescription = "비오는 날씨"
            updateWeatherUI(backgroundColor: .rainyBackground, imageName: "largeRainy", temperature: temp, weatherState: weatherState)
            updateFoodRecommendations(for: "rainy", with: recommendations)
        case .cloudy:
            weatherDescription = "흐린 날씨"
            updateWeatherUI(backgroundColor: .cloudyBackground, imageName: "largeCloudy", temperature: temp, weatherState: weatherState)
            updateFoodRecommendations(for: "cloudy", with: recommendations)
        case .fewCloudy:
            weatherDescription = "구름 조금"
            updateWeatherUI(backgroundColor: .fewCloudyBackground, imageName: "largeFewCloudy", temperature: temp, weatherState: weatherState)
            updateFoodRecommendations(for: "fewCloudy", with: recommendations)
        }
        
        foodWeatherView.weatherLine1Label.text = "\(weatherDescription), 맛있는 선택"
        foodWeatherView.weatherLine2Label.text = "현재기온 \(temp)°에 먹는 맛 여기서 찾기"
    }

    private func updateWeatherUI(backgroundColor: UIColor, imageName: String, temperature: Int, weatherState: WeatherModel) {
        DispatchQueue.main.async {
            self.view.backgroundColor = backgroundColor
            self.foodWeatherView.weatherImage.image = UIImage(named: imageName)
            self.foodWeatherView.currentTemperatureLabel.text = "\(temperature)°"
            
            self.foodWeatherView.updateWeatherConstraints(
                topOffset: weatherState == .sunny ? 120 : weatherState == .rainy ? 130 : weatherState == .fewCloudy ? 110 : 105,
                leadingOffset: weatherState == .sunny ? 24 : weatherState == .rainy ? 10 : weatherState == .fewCloudy ? 15 : -64,
                width: weatherState == .sunny ? 262 : weatherState == .rainy ? 252 : weatherState == .fewCloudy ? 357 : 340,
                height: weatherState == .sunny ? 262 : weatherState == .rainy ? 252 : weatherState == .fewCloudy ? 298 : 340
            )
        }
    }
    
    private func updateFoodRecommendations(for weather: String, with recommendations: WeatherRecommendations?) {
        guard let recommendations = recommendations else { return }
        if let food = recommendations.weatherRecommendations[weather] {
            foodSuggestionsView.koreanMenuLabel.text = food.korean.joined(separator: ", ")
            foodSuggestionsView.westernMenuLabel.text = food.western.joined(separator: ", ")
            foodSuggestionsView.chineseMenuLabel.text = food.chinese.joined(separator: ", ")
            foodSuggestionsView.japaneseMenuLabel.text = food.japanese.joined(separator: ", ")
        }
    }

    // 제약 조건 설정 함수
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.edges.equalTo(contentsView)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        contentsView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        weatherAndLocationStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.leading.equalToSuperview().inset(20)
        }
        
        foodWeatherView.snp.makeConstraints {
            $0.top.equalTo(weatherAndLocationStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        foodSuggestionsView.snp.makeConstraints {
            $0.top.equalTo(foodWeatherView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
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
