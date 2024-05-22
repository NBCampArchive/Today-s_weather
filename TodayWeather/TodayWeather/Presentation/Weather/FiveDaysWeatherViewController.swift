//
//  FiveDaysWeatherViewController.swift
//  TodayWeather
//
//  Created by 예슬 on 5/20/24.
//

import SnapKit
import UIKit

class FiveDaysWeatherViewController: UIViewController {
    var longitude: Double = 0 {
        didSet {
            callAPI()
        }
    }
    
    var latitude: Double = 0
    
    var weatherByDay: [(day: String, weather: [ForecastItem])] = []
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .rainyBackground
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.shared.requestLocation { [weak self] location in
            guard let location = location else { return }
            self?.latitude = location.coordinate.latitude
            self?.longitude = location.coordinate.longitude
            
            print("Latitude: \(self?.latitude ?? 0)")
            print("Longitude: \(self?.longitude ?? 0)")
        }
        
        configureUI()
        setConstraints()
    }
    
    // MARK: - 데이터 관련
    private func callAPI() {
        WeatherAPIManager.shared.getForecastWeatherData(latitude: self.latitude, longitude: self.longitude) { result in
            switch result{
                case .success(let data):
                    self.weatherByDay = self.groupAndSortWeatherDataByDay(data)
                    print("--------------------------------------------")
                    print("\(self.weatherByDay.count)\(self.weatherByDay)")
                    self.tableView.reloadData()
                    //                    print("getForecastWeatherData Success : \(data)")
                case .failure(let error):
                    print("getForecastWeatherData Failure \(error)")
            }
        }
    }
    
    func dayOfWeek(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    private func groupAndSortWeatherDataByDay(_ forecastResponse: ForecastResponseModel) -> [(String, [ForecastItem])] {
        var weatherByDay: [String: [ForecastItem]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 그룹화
        for forecastItem in forecastResponse.list {
            let dateString = forecastItem.dtTxt.components(separatedBy: " ").first ?? ""
            if let existingItems = weatherByDay[dateString] {
                weatherByDay[dateString] = existingItems + [forecastItem]
            } else {
                weatherByDay[dateString] = [forecastItem]
            }
        }
        
        // 그룹 내에서 정렬
        for (key, var items) in weatherByDay {
            items.sort { $0.dtTxt < $1.dtTxt }
            weatherByDay[key] = items
        }
        
        // 전체를 정렬
        let sortedWeatherByDay = weatherByDay.sorted { (entry1, entry2) -> Bool in
            guard let date1 = dateFormatter.date(from: entry1.key),
                  let date2 = dateFormatter.date(from: entry2.key) else {
                return false
            }
            return date1 < date2
        }
        return sortedWeatherByDay
    }
    // MARK: - UI 함수
    private func configureUI() {
        view.backgroundColor = .rainyBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: WeatherTableViewHeaderView.identifier)
        tableView.register(FiveDaysWeatherTableViewCell.self, forCellReuseIdentifier: FiveDaysWeatherTableViewCell.identifier)
        
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(64)
            $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource

extension FiveDaysWeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherTableViewHeaderView.identifier) as? WeatherTableViewHeaderView else { return UIView() }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(weatherByDay.count, 5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysWeatherTableViewCell.identifier, for: indexPath) as? FiveDaysWeatherTableViewCell else { return UITableViewCell() }
        
        let data = weatherByDay[indexPath.row]
        cell.configureUI(with: data)
        
        return cell
    }
}
