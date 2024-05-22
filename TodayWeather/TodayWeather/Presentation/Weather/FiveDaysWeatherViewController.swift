//
//  FiveDaysWeatherViewController.swift
//  TodayWeather
//
//  Created by 예슬 on 5/20/24.
//

import UIKit

class FiveDaysWeatherViewController: UIViewController {
    var longitude: Double = 0 {
        didSet {
            //callAPIs()
        }
    }
    
    var latitude: Double = 0
    
    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .rainyBackground
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        LocationManager.shared.requestLocation { [weak self] location in
//            guard let location = location else { return }
//            self?.latitude = location.coordinate.latitude
//            self?.longitude = location.coordinate.longitude
//            
//            print("Latitude: \(self?.latitude ?? 0)")
//            print("Longitude: \(self?.longitude ?? 0)")
//        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: WeatherTableViewHeaderView.identifier)
        tableView.register(FiveDaysWeatherTableViewCell.self, forCellReuseIdentifier: FiveDaysWeatherTableViewCell.identifier)
        
        configureUI()
        setConstraints()
    }
    // MARK: - UI 함수
    private func configureUI() {
        view.backgroundColor = .rainyBackground
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysWeatherTableViewCell.identifier, for: indexPath) as? FiveDaysWeatherTableViewCell else { return UITableViewCell() }
        return cell
    }
}
