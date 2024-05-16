//
//  FoodRecommendationViewController.swift
//  TodayWeather
//
//  Created by Developer_P on 5/16/24.
//
import UIKit
import Foundation
import Then

class FoodViewController: UIViewController {
    
    private var foodRecommendations: [FoodRecommendation] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        // tableView.register(FoodRecommendationCell.self, forCellReuseIdentifier: "FoodRecommendationCell")
        return tableView
    }()
    
    private let tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        return button
    }()
    
    private let clothesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clothes", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(clothesTapped), for: .touchUpInside)
        return button
    }()
    
    private let selectedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var selectedIndicatorLeadingConstraint: NSLayoutConstraint!
    
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
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#E67A4A")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 140 // 280/2
        view.clipsToBounds = true
        return view
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
        label.font = UIFont.systemFont(ofSize: 17)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // 기본 배경색 설정
        
        setupTabBar()
        setupHeader()
        setupWeatherDescription()
        setupSuggestionsView()
        setupContentView()
        fetchWeatherData()
    }
    
    private func setupTabBar() {
        view.addSubview(tabBarStackView)
        
        tabBarStackView.addArrangedSubview(menuButton)
        tabBarStackView.addArrangedSubview(clothesButton)
        
        NSLayoutConstraint.activate([
            tabBarStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(selectedIndicator)
        selectedIndicatorLeadingConstraint = selectedIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        
        NSLayoutConstraint.activate([
            selectedIndicator.bottomAnchor.constraint(equalTo: tabBarStackView.bottomAnchor),
            selectedIndicator.heightAnchor.constraint(equalToConstant: 3),
            selectedIndicatorLeadingConstraint,
            selectedIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupHeader() {
        view.addSubview(dateLabel)
        view.addSubview(locationIcon)
        view.addSubview(cityLabel)
        view.addSubview(countryLabel)
        view.addSubview(circleView)
        view.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: tabBarStackView.bottomAnchor, constant: 25),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            locationIcon.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            locationIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationIcon.widthAnchor.constraint(equalToConstant: 24),
            locationIcon.heightAnchor.constraint(equalToConstant: 24),
            
            cityLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8),
            
            countryLabel.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 8),
            
            circleView.centerYAnchor.constraint(equalTo: countryLabel.centerYAnchor),
            circleView.leadingAnchor.constraint(equalTo: countryLabel.trailingAnchor, constant: 8),
            circleView.widthAnchor.constraint(equalToConstant: 280),
            circleView.heightAnchor.constraint(equalToConstant: 280),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 24),
            temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupWeatherDescription() {
        view.addSubview(weatherDescriptionLabel)
        
        NSLayoutConstraint.activate([
            weatherDescriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 40),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSuggestionsView() {
        view.addSubview(suggestionsTitleLabel)
        view.addSubview(suggestionsView)
        
        suggestionsView.addSubview(koreanFoodLabel)
        suggestionsView.addSubview(koreanMenuLabel)
        suggestionsView.addSubview(westernFoodLabel)
        suggestionsView.addSubview(westernMenuLabel)
        suggestionsView.addSubview(chineseFoodLabel)
        suggestionsView.addSubview(chineseMenuLabel)
        suggestionsView.addSubview(japaneseFoodLabel)
        suggestionsView.addSubview(japaneseMenuLabel)
        
        NSLayoutConstraint.activate([
            suggestionsTitleLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 40),
            suggestionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            suggestionsView.topAnchor.constraint(equalTo: suggestionsTitleLabel.bottomAnchor, constant: 10),
            suggestionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            suggestionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            koreanFoodLabel.topAnchor.constraint(equalTo: suggestionsView.topAnchor),
            koreanFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            
            koreanMenuLabel.centerYAnchor.constraint(equalTo: koreanFoodLabel.centerYAnchor),
            koreanMenuLabel.leadingAnchor.constraint(equalTo: koreanFoodLabel.trailingAnchor, constant: 8),
            
            westernFoodLabel.topAnchor.constraint(equalTo: koreanFoodLabel.bottomAnchor, constant: 10),
            westernFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            
            westernMenuLabel.centerYAnchor.constraint(equalTo: westernFoodLabel.centerYAnchor),
            westernMenuLabel.leadingAnchor.constraint(equalTo: westernFoodLabel.trailingAnchor, constant: 8),
            
            chineseFoodLabel.topAnchor.constraint(equalTo: westernFoodLabel.bottomAnchor, constant: 10),
            chineseFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            
            chineseMenuLabel.centerYAnchor.constraint(equalTo: chineseFoodLabel.centerYAnchor),
            chineseMenuLabel.leadingAnchor.constraint(equalTo: chineseFoodLabel.trailingAnchor, constant: 8),
            
            japaneseFoodLabel.topAnchor.constraint(equalTo: chineseFoodLabel.bottomAnchor, constant: 10),
            japaneseFoodLabel.leadingAnchor.constraint(equalTo: suggestionsView.leadingAnchor),
            
            japaneseMenuLabel.centerYAnchor.constraint(equalTo: japaneseFoodLabel.centerYAnchor),
            japaneseMenuLabel.leadingAnchor.constraint(equalTo: japaneseFoodLabel.trailingAnchor, constant: 8),
            japaneseMenuLabel.bottomAnchor.constraint(equalTo: suggestionsView.bottomAnchor)
        ])
    }
    
    private func setupContentView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: suggestionsView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func menuTapped() {
        menuButton.setTitleColor(.black, for: .normal)
        clothesButton.setTitleColor(.gray, for: .normal)
        selectedIndicatorLeadingConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        // Menu 뷰를 로드
        loadMenuView()
    }
    
    @objc private func clothesTapped() {
        menuButton.setTitleColor(.gray, for: .normal)
        clothesButton.setTitleColor(.black, for: .normal)
        selectedIndicatorLeadingConstraint.constant = view.frame.width / 2
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        // Clothes 뷰를 로드
        loadClothesView()
    }
    
    private func loadMenuView() {
        // 메뉴 관련 데이터를 로드하고 테이블 뷰를 업데이트하는 코드를 작성합니다.
        fetchFoodRecommendations()
    }
    
    private func loadClothesView() {
        // 옷 관련 데이터를 로드하고 테이블 뷰를 업데이트하는 코드를 작성합니다.
        // 예시: 옷 추천 데이터를 로드하는 함수 호출
        // fetchClothesRecommendations()
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
            view.backgroundColor = .yellow
        case "rainy":
            view.backgroundColor = .gray
        case "cloudy":
            view.backgroundColor = .lightGray
        case "snowy":
            view.backgroundColor = .white
        default:
            view.backgroundColor = .white
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

