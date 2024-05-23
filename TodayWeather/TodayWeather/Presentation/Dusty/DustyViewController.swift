//
//  DustyViewController.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/14/24.
//

import UIKit
import SnapKit
import Then
import Combine

class DustyViewController: UIViewController{
    
    let dotAnimationView = DotAnimationView().then{
        $0.layer.cornerRadius = 140
        $0.layer.masksToBounds = true
    }
    
    let dayAndLocationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    let dayLabel = UILabel().then {
        $0.text = WeatherViewController().configureDate()
        $0.font = Gabarito.bold.of(size: 17)
        $0.textColor = .black
    }
    
    let locationCityLabel = UILabel().then {
        $0.text = "Seoul"
        $0.font = Gabarito.bold.of(size: 32)
        $0.textColor = .black
        $0.backgroundColor = .clear
    }
    
    let locationCountryLabel = UILabel().then {
        $0.text = "Korea"
        $0.font = Gabarito.bold.of(size: 15)
        $0.textColor = .black
    }
    
    let locationImageView = UIImageView().then {
        $0.image = UIImage(named: "locationMark")
        $0.contentMode = .scaleAspectFit
    }
    
    let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    let locationLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .firstBaseline
    }
    
    let optionSegment = SegmentControlView()
    
    var longitude: Double = 0.0 {
        didSet{
            self.fetchDustyData(for: 0)
        }
    }
    
    var latitude: Double = 0.0
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherDataManager.shared.$weatherData
            .sink { [weak self] weatherData in
                guard let weatherData = weatherData else { return }
                CurrentWeather.id = weatherData.weather[0].id
                self?.view.backgroundColor = CurrentWeather.shared.weatherColor()
                self?.optionSegment.backgroundColor = CurrentWeather.shared.weatherColor()
                self?.latitude = weatherData.coord.lat
                self?.longitude = weatherData.coord.lon
                self?.fetchLocationData(with: weatherData)
            }
            .store(in: &cancellable)
        
        optionSegment.buttons.forEach { button in
            button.addTarget(self, action: #selector(segmentButtonTapped(_:)), for: .touchUpInside)
        }
        
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dotAnimationView.startAnimatingDots()
    }
    
    func setupLayout() {
        view.addSubview(dotAnimationView)
        view.addSubview(dayAndLocationStackView)
        dayAndLocationStackView.addArrangedSubview(dayLabel)
        dayAndLocationStackView.addArrangedSubview(locationStackView)

        locationStackView.addArrangedSubview(locationImageView)
        locationStackView.addArrangedSubview(locationLabelStackView)
        
        locationLabelStackView.addArrangedSubview(locationCityLabel)
        locationLabelStackView.addArrangedSubview(locationCountryLabel)
        view.addSubview(optionSegment)
        
        dayAndLocationStackView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(77)
            $0.leading.equalToSuperview().offset(20)
        }
        
        dotAnimationView.snp.makeConstraints{
            $0.top.equalTo(locationLabelStackView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(280)
        }
        
        optionSegment.snp.makeConstraints{
            $0.top.equalTo(dotAnimationView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
    
    func fetchDustyData(for index: Int) {
        DustAPIManager.shared.getDustData(latitude: self.latitude, longitude: self.longitude) { result in
            switch result {
            case .success(let data):
                
                let pollutant = self.optionSegment.segmentTitles[index]
                let value = self.getPollutantValue(for: pollutant, from: data)
                let (airQuality, colorName) = self.determineAirQualityAndColor(for: value, pollutant: pollutant)
                
                // Update dotCount based on airQuality
                switch airQuality {
                case "Good":
                    self.dotAnimationView.dotCount = 5
                case "Normal":
                    self.dotAnimationView.dotCount = 10
                case "Unhealthy":
                    self.dotAnimationView.dotCount = 15
                default:
                    self.dotAnimationView.dotCount = 0
                }
                
                DispatchQueue.main.async {
                    self.updateLabel(self.dotAnimationView.aqiValueLabel, withText: String(Int(value)))
                    self.updateLabel(self.dotAnimationView.aqiOptionLabel, withText: pollutant)
                    self.updateLabel(self.dotAnimationView.aqiQualityLabel, withText: airQuality)
                    
                    self.dotAnimationView.backgroundColor = UIColor(named: colorName)
                    
                    self.optionSegment.selectedColor = self.dotAnimationView.backgroundColor
                }
            case .failure(let error):
                print("getDustData Failure \(error)")
            }
        }
    }
    
    func fetchLocationData(with weather: CurrentResponseModel){
        CurrentWeather.shared.reverseGeocode(latitude: weather.coord.lat, longitude: weather.coord.lon, save: false) { data in
            switch data{
            case .success(let name) :
                self.locationCityLabel.text = name[0]
                self.locationCountryLabel.text = name[1]
            case .failure(let error) :
                print("Reverse Geocode Error: \(error)")
            }
        }
    }
    
    @objc private func segmentButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        optionSegment.selectedIndex = selectedIndex
        print("Selected Index: \(selectedIndex)")
        updateDustData(for: selectedIndex)
    }
    
    private func countryName(countryCode: String) -> String? {
        let current = Locale(identifier: "en_US")
        return current.localizedString(forRegionCode: countryCode)
    }
    
    private func updateDustData(for index: Int) {
        fetchDustyData(for: index)
    }
    
    private func getPollutantValue(for pollutant: String, from data: DustResponseModel) -> Double {
        switch pollutant {
        case "AQI":
            return Double(data.data.aqi)
        case "PM10":
            print(data.data.iaqi.pm10?.v)
            return data.data.iaqi.pm10?.v ?? 0.0
        case "PM2.5":
            return data.data.iaqi.pm25?.v ?? 0.0
        case "O3":
            return data.data.iaqi.o3?.v ?? 0.0
        case "NO2":
            return data.data.iaqi.no2?.v ?? 0.0
        case "CO":
            return data.data.iaqi.co?.v ?? 0.0
        case "SO2":
            return data.data.iaqi.so2?.v ?? 0.0
        default:
            return 0.0
        }
    }
    
    func determineAirQualityAndColor(for value: Double, pollutant: String) -> (String, String) {
        switch pollutant {
        case "AQI":
            if value <= 50 {
                return ("Good", "good")
            } else if value <= 100 {
                return ("Normal", "normal")
            } else {
                return ("Unhealthy", "bad")
            }
        case "O3":
            if value <= 50 {
                return ("Good", "good")
            } else if value <= 100 {
                return ("Normal", "normal")
            } else {
                return ("Unhealthy", "bad")
            }
        case "NO2":
            if value <= 53 {
                return ("Good", "good")
            } else if value <= 100 {
                return ("Normal", "normal")
            } else {
                return ("Unhealthy", "bad")
            }
        case "CO":
            if value <= 4.4 {
                return ("Good", "good")
            } else if value <= 9.4 {
                return ("Normal", "normal")
            } else {
                return ("Unhealthy", "bad")
            }
        case "SO2":
            if value <= 35 {
                return ("Good", "good")
            } else if value <= 75 {
                return ("Normal", "normal")
            } else {
                return ("Unhealthy", "bad")
            }
        case "PM10":
            if value <= 50 {
                return ("Good", "good")
            } else if value <= 100 {
                return ("Normal", "normal")
            } else {
                return ("Unhealthy", "bad")
            }
        case "PM2.5":
            if value <= 25 {
                return ("Good", "good")
            } else if value <= 50 {
                return ("Normal", "normal")
            } else {
                return ("Unhealthy", "bad")
            }
        default:
            return ("Unknown", "unknown")
        }
    }
    
    // 텍스트 변경 시 애니메이션을 추가하는 함수
    private func updateLabel(_ label: UILabel, withText text: String) {
        let animation = CATransition()
        animation.type = .push
        animation.subtype = .fromTop
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        label.layer.add(animation, forKey: "changeTextTransition")
        label.text = text
    }
    
}
