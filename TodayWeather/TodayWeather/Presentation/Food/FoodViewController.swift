import UIKit
import Foundation

class FoodViewController: UIViewController {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Friday August 8"
        label.font = UIFont(name: "Gabarito", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "locationMark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Seoul"
        if let customFont = UIFont(name: "Gabarito-Bold", size: 32) {
            label.font = customFont
        } else {
            label.font = UIFont(name: "Gabarito", size: 32)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Korea"
        label.font = UIFont(name: "Gabarito", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "smallSunny")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "30°"
        label.font = UIFont(name: "Bagel Fat One", size: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherLine1Label: UILabel = {
        let label = UILabel()
        label.text = "OO날씨, 맛있는 선택"
        label.font = UIFont(name: "Pretendard", size: 14)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherLine2Label: UILabel = {
        let label = UILabel()
        label.text = "오늘같이 OO날에 먹는 맛 여기서 찾기"
        label.font = UIFont(name: "Pretendard", size: 14)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherLine3Label: UILabel = {
        let label = UILabel()
        label.text = "무엇을 먹을지 고민되는 하루"
        label.font = UIFont(name: "Pretendard", size: 14)
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let suggestionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이런 음식은 어떠세요?"
        label.font = UIFont(name: "Pretendard", size: 12)
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
        label.font = UIFont(name: "Pretendard", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let koreanMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "비빔밥, 김치찌개, 불고기"
        label.font = UIFont(name: "Pretendard", size: 14)
        label.textColor = .black // 텍스트 색상을 검은색으로 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let koreanSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black // 배경 색상을 검은색으로 설정
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let westernFoodLabel: UILabel = {
        let label = UILabel()
        label.text = "양식"
        label.font = UIFont(name: "Pretendard", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let westernMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "스테이크, 파스타, 피자"
        label.font = UIFont(name: "Pretendard", size: 14)
        label.textColor = .black // 텍스트 색상을 검은색으로 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let westernSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black // 배경 색상을 검은색으로 설정
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let chineseFoodLabel: UILabel = {
        let label = UILabel()
        label.text = "중식"
        label.font = UIFont(name: "Pretendard", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chineseMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "짜장면, 탕수육, 마라탕"
        label.font = UIFont(name: "Pretendard", size: 14)
        label.textColor = .black // 텍스트 색상을 검은색으로 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chineseSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black // 배경 색상을 검은색으로 설정
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let japaneseFoodLabel: UILabel = {
        let label = UILabel()
        label.text = "일식"
        label.font = UIFont(name: "Pretendard", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let japaneseMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "초밥, 라멘, 우동"
        label.font = UIFont(name: "Pretendard", size: 14)
        label.textColor = .black // 텍스트 색상을 검은색으로 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let japaneseSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .black // 배경 색상을 검은색으로 설정
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "fewCloudyBackground")
        
        setupHeader()
        setupWeatherDescription()
        setupSuggestionsView()
        fetchWeatherData()
    }
    
    private func setupHeader() {
        view.addSubview(circleImageView)
        view.addSubview(dateLabel)
        view.addSubview(locationIcon)
        view.addSubview(cityLabel)
        view.addSubview(countryLabel)
        view.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            locationIcon.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            locationIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationIcon.widthAnchor.constraint(equalToConstant: 24),
            locationIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            countryLabel.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            circleImageView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 54),
            circleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            circleImageView.widthAnchor.constraint(equalToConstant: 280),
            circleImageView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 80),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupWeatherDescription() {
        view.addSubview(weatherLine1Label)
        view.addSubview(weatherLine2Label)
        view.addSubview(weatherLine3Label)
        view.addSubview(suggestionsTitleLabel)

        NSLayoutConstraint.activate([
            weatherLine1Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherLine1Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherLine1Label.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            weatherLine2Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherLine2Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherLine2Label.topAnchor.constraint(equalTo: weatherLine1Label.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            weatherLine3Label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherLine3Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherLine3Label.topAnchor.constraint(equalTo: weatherLine2Label.bottomAnchor, constant: 10)
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
            suggestionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            suggestionsTitleLabel.bottomAnchor.constraint(equalTo: suggestionsView.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            suggestionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            suggestionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            suggestionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
        
        NSLayoutConstraint.activate([
            koreanFoodLabel.topAnchor.constraint(equalTo: suggestionsView.topAnchor),
            koreanFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            koreanMenuLabel.centerYAnchor.constraint(equalTo: koreanFoodLabel.centerYAnchor),
            koreanMenuLabel.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            koreanSeparator.topAnchor.constraint(equalTo: koreanFoodLabel.bottomAnchor, constant: 8),
            koreanSeparator.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            koreanSeparator.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor),
            koreanSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            westernFoodLabel.topAnchor.constraint(equalTo: koreanSeparator.bottomAnchor, constant: 20),
            westernFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            westernMenuLabel.centerYAnchor.constraint(equalTo: westernFoodLabel.centerYAnchor),
            westernMenuLabel.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            westernSeparator.topAnchor.constraint(equalTo: westernFoodLabel.bottomAnchor, constant: 8),
            westernSeparator.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            westernSeparator.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor),
            westernSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            chineseFoodLabel.topAnchor.constraint(equalTo: westernSeparator.bottomAnchor, constant: 20),
            chineseFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chineseMenuLabel.centerYAnchor.constraint(equalTo: chineseFoodLabel.centerYAnchor),
            chineseMenuLabel.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            chineseSeparator.topAnchor.constraint(equalTo: chineseFoodLabel.bottomAnchor, constant: 8),
            chineseSeparator.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            chineseSeparator.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor),
            chineseSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            japaneseFoodLabel.topAnchor.constraint(equalTo: chineseSeparator.bottomAnchor, constant: 20),
            japaneseFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            japaneseMenuLabel.centerYAnchor.constraint(equalTo: japaneseFoodLabel.centerYAnchor),
            japaneseMenuLabel.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            japaneseSeparator.topAnchor.constraint(equalTo: japaneseFoodLabel.bottomAnchor, constant: 8),
            japaneseSeparator.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            japaneseSeparator.trailingAnchor.constraint(equalTo: suggestionsView.trailingAnchor),
            japaneseSeparator.heightAnchor.constraint(equalToConstant: 1),
            japaneseSeparator.bottomAnchor.constraint(equalTo: suggestionsView.bottomAnchor)
        ])
    }
    
    private func fetchWeatherData() {
        // 더미 날씨 데이터
        let weather = "largeSunny"
        updateBackgroundColor(for: weather)
        
        // 여기서 네트워크 호출을 통해 실제 날씨 데이터를 가져오고, 날씨에 따라 배경 색상을 업데이트하세요.
    }
    
    private func updateBackgroundColor(for weather: String) {
        switch weather {
        case "largeSunny":
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
}
