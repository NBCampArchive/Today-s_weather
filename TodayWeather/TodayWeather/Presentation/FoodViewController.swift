import UIKit
import Foundation

class FoodViewController: UIViewController {
    
    private var foodRecommendations: [FoodRecommendation] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Friday August 8"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "map.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Seoul"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Korea"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "smallSunny") // Update with your asset name
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "25°" // This would be set dynamically
        label.font = UIFont.systemFont(ofSize: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "더운 날씨, 맛있는 선택\n현재 기온 25°\n에 먹는 맛 여기서 찾기\n무더운 날 뭐먹을지 고민 되는 하루"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let suggestionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이런 음식은 어떠세요?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let suggestionsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let koreanFoodLabel: UILabel = {
        let label = UILabel()
        label.text = "한식"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let koreanMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "비빔밥, 김치찌개, 불고기"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let koreanSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let westernFoodLabel: UILabel = {
        let label = UILabel()
        label.text = "양식"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let westernMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "스테이크, 파스타, 피자"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let westernSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let chineseFoodLabel: UILabel = {
        let label = UILabel()
        label.text = "중식"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chineseMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "짜장면, 탕수육, 마라탕"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chineseSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let japaneseFoodLabel: UILabel = {
        let label = UILabel()
        label.text = "일식"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let japaneseMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "초밥, 라멘, 우동"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let japaneseSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "fewCloudyBackground") // Update with your asset name
        
        setupHeader()
        setupWeatherDescription()
        setupSuggestionsView()
        setupContentView()
        fetchWeatherData()
    }
    
    
    
    private func setupHeader() {
        view.addSubview(dateLabel)
        view.addSubview(locationIcon)
        view.addSubview(cityLabel)
        view.addSubview(countryLabel)
        view.addSubview(circleImageView)
        view.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80), // 이전: 60
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            locationIcon.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30), // 이전: 20
            locationIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationIcon.widthAnchor.constraint(equalToConstant: 24),
            locationIcon.heightAnchor.constraint(equalToConstant: 24),
            
            cityLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8),
            
            countryLabel.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 8),
            
            circleImageView.centerYAnchor.constraint(equalTo: countryLabel.centerYAnchor),
            circleImageView.leadingAnchor.constraint(equalTo: countryLabel.trailingAnchor, constant: 8),
            circleImageView.widthAnchor.constraint(equalToConstant: 280),
            circleImageView.heightAnchor.constraint(equalToConstant: 280),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 60), // 이전: 40
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupWeatherDescription() {
        view.addSubview(weatherDescriptionLabel)
        
        NSLayoutConstraint.activate([
            weatherDescriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 100), // Adjusted down
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSuggestionsView() {
        view.addSubview(suggestionsTitleLabel)
        view.addSubview(suggestionsView)
        
        suggestionsView.addSubview(koreanFoodLabel)
        suggestionsView.addSubview(koreanMenuLabel)
        suggestionsView.addSubview(koreanSeparator)
        suggestionsView.addSubview(westernFoodLabel)
        suggestionsView.addSubview(westernMenuLabel)
        suggestionsView.addSubview(westernSeparator)
        suggestionsView.addSubview(chineseFoodLabel)
        suggestionsView.addSubview(chineseMenuLabel)
        suggestionsView.addSubview(chineseSeparator)
        suggestionsView.addSubview(japaneseFoodLabel)
        suggestionsView.addSubview(japaneseMenuLabel)
        suggestionsView.addSubview(japaneseSeparator)
        
        NSLayoutConstraint.activate([
            suggestionsTitleLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 40), // Adjusted down
            suggestionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            suggestionsView.topAnchor.constraint(equalTo: suggestionsTitleLabel.bottomAnchor, constant: 20),
            suggestionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            suggestionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            koreanFoodLabel.topAnchor.constraint(equalTo: suggestionsView.topAnchor),
            koreanFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            
            koreanMenuLabel.centerYAnchor.constraint(equalTo: koreanFoodLabel.centerYAnchor),
            koreanMenuLabel.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor, constant: -16), // 오른쪽 배치
            
            koreanSeparator.topAnchor.constraint(equalTo: koreanFoodLabel.bottomAnchor, constant: 8),
            koreanSeparator.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            koreanSeparator.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor),
            koreanSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            westernFoodLabel.topAnchor.constraint(equalTo: koreanSeparator.bottomAnchor, constant: 20),
            westernFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            
            westernMenuLabel.centerYAnchor.constraint(equalTo: westernFoodLabel.centerYAnchor),
            westernMenuLabel.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor, constant: -16), // 오른쪽 배치
            
            westernSeparator.topAnchor.constraint(equalTo: westernFoodLabel.bottomAnchor, constant: 8),
            westernSeparator.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            westernSeparator.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor),
            westernSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            chineseFoodLabel.topAnchor.constraint(equalTo: westernSeparator.bottomAnchor, constant: 20),
            chineseFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            
            chineseMenuLabel.centerYAnchor.constraint(equalTo: chineseFoodLabel.centerYAnchor),
            chineseMenuLabel.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor, constant: -16), // 오른쪽 배치
            
            chineseSeparator.topAnchor.constraint(equalTo: chineseFoodLabel.bottomAnchor, constant: 8),
            chineseSeparator.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            chineseSeparator.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor),
            chineseSeparator.heightAnchor.constraint(equalToConstant: 1),
            
            japaneseFoodLabel.topAnchor.constraint(equalTo: chineseSeparator.bottomAnchor, constant: 20),
            japaneseFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            
            japaneseMenuLabel.centerYAnchor.constraint(equalTo: japaneseFoodLabel.centerYAnchor),
            japaneseMenuLabel.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor, constant: -16), // 오른쪽 배치
            
            japaneseSeparator.topAnchor.constraint(equalTo: japaneseFoodLabel.bottomAnchor, constant: 8),
            japaneseSeparator.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            japaneseSeparator.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor),
            japaneseSeparator.heightAnchor.constraint(equalToConstant: 1),
            japaneseSeparator.bottomAnchor.constraint(equalTo: suggestionsView.bottomAnchor)
        ])
    }
    
    private func setupContentView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: suggestionsView.bottomAnchor, constant: 60), // Adjusted down
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchWeatherData() {
        // 더미 날씨 데이터
        let weather = "sunny"
        updateBackgroundColor(for: weather)
        
        // 여기서 네트워크 호출을 통해 실제 날씨 데이터를 가져오고, 날씨에 따라 배경 색상을 업데이트하세요.
    }
    
    private func updateBackgroundColor(for weather: String) {
        switch weather {
        case "sunny":
            view.backgroundColor = UIColor(named: "sunnyBackground")
        case "rainy":
            view.backgroundColor = UIColor(named: "rainyBackground")
        case "cloudy":
            view.backgroundColor = UIColor(named: "fewCloudyBackground")
        case "snowy":
            view.backgroundColor = UIColor(named: "snowyBackground")
        default:
            view.backgroundColor = UIColor(named: "defaultBackground")
        }
    }
    
    private func fetchFoodRecommendations() {
        // Network call to fetch weather information and then get food recommendations based on weather
        // For now, let's use dummy data
        foodRecommendations = [
            FoodRecommendation(name: "Pasta", description: "Delicious Italian pasta.", imageUrl: "pasta.jpg"),
            FoodRecommendation(name: "Sushi", description: "Fresh sushi.", imageUrl: "sushi.jpg")
        ]
        tableView.reloadData()
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
