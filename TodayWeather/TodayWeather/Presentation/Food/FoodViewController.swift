import Foundation
import Alamofire
import Combine
import SnapKit
import Then
import UIKit

class FoodViewController: UIViewController {
    
    internal var cancellable = Set<AnyCancellable>()
    
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
    
    internal let scrollView = UIScrollView().then { $0.showsVerticalScrollIndicator = false
    }
    internal let contentsView = UIView()
    
    internal let foodLocationView = FoodLocationView()
    internal let foodWeatherView = FoodWeatherView()
    internal let foodSuggestionsView = FoodSuggestionsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "fewCloudyBackground")
        
        configureUI()
        setConstraints()
        
        let recommendations = loadWeatherRecommendations()
        updateFoodRecommendations(for: "sunny", with: recommendations)
        
        callAPIs()
        
        LocationManager.shared.requestLocation { [weak self] location in
            guard let location = location else { return }
            self?.latitude = location.coordinate.latitude
            self?.longitude = location.coordinate.longitude
            print("Latitude: \(self?.latitude ?? 0)")
            print("Longitude: \(self?.longitude ?? 0)")
        }
    }
    
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
    
    private func configureUI() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentsView)
        contentsView.addSubviews(foodLocationView, foodWeatherView, foodSuggestionsView)
    }
    
    private func configureLabel() {
        foodLocationView.cityLabel.text = weatherData?.name
        foodLocationView.countryLabel.text = countryName(countryCode: weatherData?.sys.country ?? "")
    }
    
    private func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
    
    private func updateUI(with weather: CurrentResponseModel) {
        guard let weatherCondition = weather.weather.first else { return }
        let weatherState = WeatherModel(id: weatherCondition.id)
        let temp = Int(weather.main.temp)
        let recommendations = loadWeatherRecommendations()
        
        let weatherDescription: String
        switch weatherState {
        case .sunny:
            weatherDescription = "맑은 날씨"
            updateWeatherUI(backgroundColor: .sunnyBackground, imageName: "largeSunny", temperature: temp)
            updateFoodRecommendations(for: "sunny", with: recommendations)
        case .rainy:
            weatherDescription = "비오는 날씨"
            updateWeatherUI(backgroundColor: .rainyBackground, imageName: "largeRainy", temperature: temp)
            updateFoodRecommendations(for: "rainy", with: recommendations)
        case .cloudy:
            weatherDescription = "흐린 날씨"
            updateWeatherUI(backgroundColor: .cloudyBackground, imageName: "largeCloudy", temperature: temp)
            updateFoodRecommendations(for: "cloudy", with: recommendations)
        case .fewCloudy:
            weatherDescription = "구름 조금"
            updateWeatherUI(backgroundColor: .fewCloudyBackground, imageName: "largeFewCloudy", temperature: temp)
            updateFoodRecommendations(for: "fewCloudy", with: recommendations)
        }
        
        foodWeatherView.weatherLine1Label.text = "\(weatherDescription), 맛있는 선택"
        foodWeatherView.weatherLine2Label.text = "현재기온 \(temp)°에 먹는 맛 여기서 찾기"
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
    
    private func updateWeatherUI(backgroundColor: UIColor, imageName: String, temperature: Int) {
        DispatchQueue.main.async {
            self.view.backgroundColor = backgroundColor
            self.foodWeatherView.weatherImage.image = UIImage(named: imageName)
            self.foodWeatherView.currentTemperatureLabel.text = String(temperature) + "°"
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

// 헬퍼 함수들
func createFoodLabel(text: String) -> UILabel {
    return UILabel().then {
        $0.text = text
        $0.font = UIFont(name: "Pretendard", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
}

func createMenuLabel(text: String) -> UILabel {
    return UILabel().then {
        $0.text = text
        $0.font = UIFont(name: "Pretendard", size: 14)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
}

func createSeparator() -> UIView {
    return UIView().then {
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
}
