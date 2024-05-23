//
//  WeatherTableViewHeaderView.swift
//  TodayWeather
//
//  Created by 예슬 on 5/21/24.
//

import SnapKit
import Then
import UIKit

class WeatherTableViewHeaderView: UITableViewHeaderFooterView {
    static let identifier = String(describing: WeatherTableViewHeaderView.self)
    
    private let dateLocationStacview = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 13
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Gabarito.medium.of(size: 13)
        $0.text = WeatherViewController().configureDate()
        $0.textColor = .black.withAlphaComponent(0.8)
    }
    
    private let locationImageLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
    }
    
    private let locationMarkImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "locationMark")
    }
    
    private let locationLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
    }
    
    private lazy var cityLabel = UILabel().then {
        $0.font = Gabarito.semibold.of(size: 18)
        $0.text = WeatherDataManager.shared.weatherData?.name
    }
    
    private let countryLabel = UILabel().then {
        $0.font = Gabarito.semibold.of(size: 18)
        $0.text = WeatherViewController().countryName(countryCode: WeatherDataManager.shared.weatherData?.sys.country ?? "US")
    }
    // MARK: - init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI
    private func configureLayout() {
        contentView.addSubview(dateLocationStacview)
        
        [dateLabel,
         locationImageLabelStackView].forEach {
            dateLocationStacview.addArrangedSubview($0)
        }
        
        [locationMarkImage,
         locationLabelStackView].forEach {
            locationImageLabelStackView.addArrangedSubview($0)
        }
        
        [cityLabel, countryLabel].forEach {
            locationLabelStackView.addArrangedSubview($0)
        }
        
        dateLocationStacview.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80).priority(.high)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
