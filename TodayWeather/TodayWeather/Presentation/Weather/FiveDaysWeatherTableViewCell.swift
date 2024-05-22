//
//  FiveDaysWeatherTableViewCell.swift
//  TodayWeather
//
//  Created by 예슬 on 5/21/24.
//

import SnapKit
import Then
import UIKit

class FiveDaysWeatherTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FiveDaysWeatherTableViewCell.self)
    
    private let temperatureDaysOfWeekStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
    }
    
    private let temperatureLable = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 40)
    }
    
    private let daysOfWeekLable = UILabel().then {
        $0.font = Gabarito.regular.of(size: 14)
        $0.textColor = .black.withAlphaComponent(0.6)
        $0.text = "Sunday"
    }
    
    private let weatherImage = UIImageView().then {
        $0.image = UIImage(named: "smallSunny")
    }
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        contentView.layer.cornerRadius = 16
    }
    
    // MARK: - UI
    private func setConstraints() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .white.withAlphaComponent(0.4)
        
        [temperatureDaysOfWeekStackView, weatherImage].forEach {
            contentView.addSubview($0)
        }
        
        [temperatureLable, daysOfWeekLable].forEach {
            temperatureDaysOfWeekStackView.addArrangedSubview($0)
        }
        
        temperatureDaysOfWeekStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        weatherImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configureUI(with weatherData: (day: String, weather: [ForecastItem])) {
        self.daysOfWeekLable.text = self.dayOfWeek(from: weatherData.day)
        self.temperatureLable.text = String(self.averageTemperature(weatherData))
        self.weatherImage.image = CurrentWeather.shared.weatherImage(weather: self.mostWeatherState(weatherData))
    }
    
    private func dayOfWeek(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
        return "--"
    }
    
    private func averageTemperature(_ weatherData: (day: String, weather: [ForecastItem])) -> Int {
        let temps = weatherData.weather.map { $0.main.temp }
        let averageTemp = Int(temps.reduce(0, +) / Double(temps.count))
        
        return averageTemp
    }
    
    private func mostWeatherState(_ weatherData: (day: String, weather: [ForecastItem])) -> Int {
        let weatherStateID = weatherData.weather.map { $0.weather.first?.id }
        var maxCount = 0
        var mostFrequentID: Int = 0
        let countedSet = NSCountedSet()
        
        for id in weatherStateID {
            if let id = id {
                countedSet.add(id)
            }
        }
        
        for id in countedSet {
            if let id = id as? Int {
                let count = countedSet.count(for: id)
                if count > maxCount {
                    maxCount = count
                    mostFrequentID = id
                }
            }
        }
        
        return mostFrequentID
    }
}
