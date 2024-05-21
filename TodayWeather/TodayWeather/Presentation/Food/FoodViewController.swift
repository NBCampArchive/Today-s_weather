import Foundation
import Alamofire
import Combine
import SnapKit
import Then
import UIKit

class FoodViewController: UIViewController {
    
    private var cancellable = Set<AnyCancellable>()
    
    var longitude: Double = 0 {
        didSet {
            callAPIs()
        }
    }
    
    var latitude: Double = 0
    
    var weatherData: CurrentResponseModel? {
        didSet {
            configureLabel()
        }
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentsView = UIView()
    
    private let weatherAndLocationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    private let locationLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .firstBaseline
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 17)
        $0.text = configureDate()
    }
    
    private let locationMarkImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "locationMark")
    }
    
    private lazy var cityLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 32)
        $0.text = weatherData?.name ?? "Cupertino"
    }
    
    private lazy var countryLabel = UILabel().then {
        $0.font = Gabarito.bold.of(size: 15)
        $0.text = weatherData?.sys.country ?? "United States"
    }
    
    private lazy var weatherImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "largeSunny")
    }
    
    private lazy var currentTemperatureLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 96)
        $0.text = String(Int(weatherData?.main.temp ?? 0)) + "°"
    }
    
    private let weatherLine1Label = UILabel().then {
        $0.text = "OO날씨, 맛있는 선택"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let weatherLine2Label = UILabel().then {
        $0.text = "현재 기온 0°에 먹는 맛 여기서 찾기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let weatherLine3Label = UILabel().then {
        $0.text = "무엇을 먹을지 고민되는 하루"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = UIColor.black.withAlphaComponent(0.4)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let suggestionsTitleLabel = UILabel().then {
        $0.text = "이런 음식은 어떠세요?"
        $0.font = UIFont(name: "Pretendard", size: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let suggestionsView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let koreanFoodLabel = UILabel().then {
        $0.text = "한식"
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let koreanMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let koreanSeparator = UIView().then {
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let westernFoodLabel = UILabel().then {
        $0.text = "양식"
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let westernMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let westernSeparator = UIView().then {
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let chineseFoodLabel = UILabel().then {
        $0.text = "중식"
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let chineseMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let chineseSeparator = UIView().then {
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let japaneseFoodLabel = UILabel().then {
        $0.text = "일식"
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let japaneseMenuLabel = UILabel().then {
        $0.text = "음식 내용 데이터 가져오기"
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let japaneseSeparator = UIView().then {
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "fewCloudyBackground")
        
        configureUI()
        setConstraints()
        
        // Load JSON and update UI
        let recommendations = loadWeatherRecommendations()
        updateFoodRecommendations(for: "sunny", with: recommendations) // Test with "sunny"
        
        callAPIs()
        
        LocationManager.shared.requestLocation { [weak self] location in
            guard let location = location else {
                print("Location data is nil")
                return
            }
            self?.latitude = location.coordinate.latitude
            self?.longitude = location.coordinate.longitude
            
            print("Latitude: \(self?.latitude ?? 0)")
            print("Longitude: \(self?.longitude ?? 0)")
        }
    }
    
    // 현재 위치를 기준으로 날씨 데이터를 가져오는 API 호출 함수
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
                            // 응답 데이터 로그 추가
                            if let data = afError.underlyingError as? Data {
                                if let json = String(data: data, encoding: .utf8) {
                                    print("Received data: \(json)")
                                }
                            }
                        default:
                            print("Other serialization error")
                        }
                    }
                }
            }, receiveValue: { data in
                print("Received data: \(data)")
                WeatherDataManager.shared.weatherData = data
                self.updateUI(with: data)
                print("GetCurrentWeatherData Success: \(data)")
            })
            .store(in: &cancellable)
    }

    
    private func loadWeatherRecommendations() -> WeatherRecommendations? {
        guard let url = Bundle.main.url(forResource: "weatherRecommendations", withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let recommendations = try decoder.decode(WeatherRecommendations.self, from: data)
            return recommendations
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    // UI 구성 요소를 초기화하고 뷰에 추가하는 함수
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentsView)
        
        // contentsView에 모든 서브 뷰 추가
        [weatherAndLocationStackView, weatherImage, currentTemperatureLabel, weatherLine1Label, weatherLine2Label, weatherLine3Label, suggestionsTitleLabel, suggestionsView
        ].forEach {
            contentsView.addSubview($0)
        }
        
        // weatherAndLocationStackView에 서브 뷰 추가
        [dateLabel,
         locationStackView].forEach {
            weatherAndLocationStackView.addArrangedSubview($0)
        }
        
        // locationStackView에 서브 뷰 추가
        [locationMarkImage,
         locationLabelStackView].forEach {
            locationStackView.addArrangedSubview($0)
        }
        
        // locationLabelStackView에 서브 뷰 추가
        [cityLabel,
         countryLabel].forEach {
            locationLabelStackView.addArrangedSubview($0)
        }
        
        // suggestionsView에 서브 뷰 추가
        [koreanFoodLabel,
         koreanMenuLabel,
         koreanSeparator,
         westernFoodLabel,
         westernMenuLabel,
         westernSeparator,
         chineseFoodLabel,
         chineseMenuLabel,
         chineseSeparator,
         japaneseFoodLabel,
         japaneseMenuLabel,
         japaneseSeparator
        ].forEach {
            suggestionsView.addSubview($0)
        }
    }
    
    // UI 요소들의 제약 조건을 설정하는 함수
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        scrollView.contentLayoutGuide.snp.makeConstraints {
            $0.edges.equalTo(contentsView)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        
        weatherAndLocationStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.leading.equalToSuperview().inset(20)
        }
        
        weatherImage.snp.makeConstraints {
            $0.top.equalTo(weatherAndLocationStackView.snp.bottom).offset(120)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(262)
            $0.height.equalTo(262)
        }
        
        currentTemperatureLabel.snp.makeConstraints {
            $0.top.equalTo(weatherImage.snp.bottom).offset(-350)
            $0.leading.equalToSuperview().inset(16)
        }
        
        weatherLine1Label.snp.makeConstraints {
            $0.top.equalTo(currentTemperatureLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        weatherLine2Label.snp.makeConstraints {
            $0.top.equalTo(weatherLine1Label.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        weatherLine3Label.snp.makeConstraints {
            $0.top.equalTo(weatherLine2Label.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        suggestionsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(weatherLine3Label.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        suggestionsView.snp.makeConstraints {
            $0.top.equalTo(suggestionsTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-90)
        }
        
        koreanFoodLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview()
        }
        
        koreanMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(koreanFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        koreanSeparator.snp.makeConstraints {
            $0.top.equalTo(koreanFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        westernFoodLabel.snp.makeConstraints {
            $0.top.equalTo(koreanSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        westernMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(westernFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        westernSeparator.snp.makeConstraints {
            $0.top.equalTo(westernFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        chineseFoodLabel.snp.makeConstraints {
            $0.top.equalTo(westernSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        chineseMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(chineseFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        chineseSeparator.snp.makeConstraints {
            $0.top.equalTo(chineseFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        japaneseFoodLabel.snp.makeConstraints {
            $0.top.equalTo(chineseSeparator.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
        }
        
        japaneseMenuLabel.snp.makeConstraints {
            $0.centerY.equalTo(japaneseFoodLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        japaneseSeparator.snp.makeConstraints {
            $0.top.equalTo(japaneseFoodLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // 날씨 데이터에 따라 라벨을 업데이트하는 함수
    private func configureLabel() {
        self.cityLabel.text = weatherData?.name
        self.countryLabel.text = countryName(countryCode: weatherData?.sys.country ?? "")
    }
    
    // 현재 날짜를 문자열로 변환하는 함수
    private func configureDate() -> String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "eeee MMMM d"
        let dateString = dateFormatter.string(from: nowDate)
        
        return dateString
    }
    
    // 국가 코드를 국가 이름으로 변환하는 함수
    private func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
    
    // 날씨 상태에 따라 UI를 업데이트하는 함수
    private func updateUI(with weather: CurrentResponseModel) {
        guard let weatherCondition = weather.weather.first else {
            print("Weather condition is nil")
            return
        }
        
        let weatherState = WeatherModel(id: weatherCondition.id)
        let temp = Int(weather.main.temp)
        var weatherDescription: String
        let recommendations = loadWeatherRecommendations()

        print("Weather condition ID: \(weatherCondition.id)")
        print("Temperature: \(temp)")

        switch weatherState {
            case .sunny:
                weatherDescription = "맑은 날씨"
                print("Weather is sunny")
                updateWeatherUI(backgroundColor: .sunnyBackground, imageName: "largeSunny", temperature: temp)
                updateFoodRecommendations(for: "sunny", with: recommendations)
            case .rainy:
                weatherDescription = "비오는 날씨"
                print("Weather is rainy")
                updateWeatherUI(backgroundColor: .rainyBackground, imageName: "largeRainy", temperature: temp)
                updateFoodRecommendations(for: "rainy", with: recommendations)
            case .cloudy:
                weatherDescription = "흐린 날씨"
                print("Weather is cloudy")
                updateWeatherUI(backgroundColor: .cloudyBackground, imageName: "largeCloudy", temperature: temp)
                updateFoodRecommendations(for: "cloudy", with: recommendations)
            case .fewCloudy:
                weatherDescription = "구름 조금"
                print("Weather is few cloudy")
                updateWeatherUI(backgroundColor: .fewCloudyBackground, imageName: "largeFewCloudy", temperature: temp)
                updateFoodRecommendations(for: "fewCloudy", with: recommendations)
        }
        
        // 라벨 텍스트 업데이트
        self.weatherLine1Label.text = "\(weatherDescription), 맛있는 선택"
        self.weatherLine2Label.text = "현재기온 \(temp)°에 먹는 맛 여기서 찾기"
        print("Updated weatherLine1Label: \(self.weatherLine1Label.text ?? "")")
        print("Updated weatherLine2Label: \(self.weatherLine2Label.text ?? "")")
    }

    private func updateFoodRecommendations(for weather: String, with recommendations: WeatherRecommendations?) {
        guard let recommendations = recommendations else { return }
        
        if let food = recommendations.weatherRecommendations[weather] {
            koreanMenuLabel.text = food.korean.joined(separator: ", ")
            westernMenuLabel.text = food.western.joined(separator: ", ")
            chineseMenuLabel.text = food.chinese.joined(separator: ", ")
            japaneseMenuLabel.text = food.japanese.joined(separator: ", ")
        }
    }
    
    private func updateWeatherUI(backgroundColor: UIColor, imageName: String, temperature: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = backgroundColor
            self.weatherImage.image = UIImage(named: imageName)
            self.currentTemperatureLabel.text = String(temperature) + "°"
        }
    }
}
