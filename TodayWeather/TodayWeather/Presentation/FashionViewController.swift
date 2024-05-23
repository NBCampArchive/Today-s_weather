//
//  FashionViewController.swift
//  TodayWeather
//
//  Created by t2023-m0074 on 5/23/24.
//

import UIKit
import SnapKit
import Then
import Combine

class FashionViewController: UIViewController {
    var cancellable = Set<AnyCancellable>()
    let scrollView = UIScrollView()
    let containerView = UIView()
    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
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
    
    let tempLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 96)
        $0.text = "25°"
    }
    let tempImageView = UIImageView()
    let tmpView = UIView()
    let markImageView = UIImageView()
    var weather : WeatherModel = .sunny
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        self.scrollView.addSubview(containerView)
        containerView.addSubview(tableView)
        containerView.addSubview(tmpView)
        tmpView.addSubview(tempImageView)
        tmpView.addSubview(tempLabel)
        configureUI()
        setupConstraints()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FashionTableViewCell.self, forCellReuseIdentifier: FashionTableViewCell.identifier)
        WeatherDataManager.shared.$weatherData.sink { [weak self] weatherData in
            guard let weatherData = weatherData else { return }
            CurrentWeather.id = weatherData.weather[0].id
            self?.view.backgroundColor = CurrentWeather.shared.weatherColor()
            self?.tempImageView.image = CurrentWeather.shared.weatherImage()
            self?.tempLabel.text = String(Int(weatherData.main.temp)) + "°"
            self?.updateUI(with: weatherData)
        }.store(in: &cancellable)
        
    }
    
    func configureUI() {
        
        tmpView.addSubview(dayAndLocationStackView)
        dayAndLocationStackView.addArrangedSubview(dayLabel)
        dayAndLocationStackView.addArrangedSubview(locationStackView)
        
        locationStackView.addArrangedSubview(locationImageView)
        locationStackView.addArrangedSubview(locationLabelStackView)
        
        locationLabelStackView.addArrangedSubview(locationCityLabel)
        locationLabelStackView.addArrangedSubview(locationCountryLabel)
        
        dayAndLocationStackView.snp.makeConstraints{
            $0.top.equalTo(tmpView.snp.top)
            $0.leading.equalTo(tmpView.snp.leading).offset(20)
        }
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(880)
            $0.width.equalTo(scrollView.snp.width)
        }
        tmpView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).inset(90)
            $0.height.equalTo(292)
            $0.width.equalTo(containerView.snp.width)
            $0.leading.equalToSuperview()
        }
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(dayAndLocationStackView.snp.bottom).offset(80)
            $0.leading.equalToSuperview().inset(20)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(tmpView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.bottom)
        }
    }
    //MARK: - updateUI
    private func updateUI(with weather: CurrentResponseModel) {
        guard let weatherCondition = weather.weather.first else { return }
        let weatherState = WeatherModel(id: weatherCondition.id)
        
        CurrentWeather.shared.reverseGeocode(latitude: weather.coord.lat, longitude: weather.coord.lon, save: false) { data in
            switch data {
                case .success(let name) :
                    self.locationCityLabel.text = name[0]
                    self.locationCountryLabel.text = name[1]
                case .failure(let error) :
                    print("Reverse geocoding error: \(error.localizedDescription)")
            }
            
        }
        
        switch weatherState {
            case .sunny:
                updateWeatherPart(top: 4, leading: 181, width: 288)
            case .rainy:
                updateWeatherPart(top: 2, leading: 181, width: 276)
            case .cloudy:
                updateWeatherPart(top: -10, leading: 181, width: 288)
            case .fewCloudy:
                updateWeatherPart(top: 0, leading: 181, width: 345)
        }
    }
    
    private func updateWeatherPart(top: Int, leading: Int, width: Int) {
        self.tempImageView.snp.updateConstraints {
            $0.top.equalTo(tmpView.snp.top).inset(top)
            $0.leading.equalTo(tmpView.snp.leading).inset(leading)
            $0.width.equalTo(width)
            $0.height.equalTo(288)
        }
    }
}

extension FashionViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FashionTableViewCell.identifier, for: indexPath) as! FashionTableViewCell
        
        cell.fashionLabel.text = "나시티,반바지,반팔"
        cell.subLabel.text = "오후"
        cell.tmpLabel.text = "21"
        return cell
    }
    
}
