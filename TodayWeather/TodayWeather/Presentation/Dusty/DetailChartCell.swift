//
//  DetailCartCell.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/21/24.
//

import UIKit
import SnapKit
import Then
import DGCharts

class DetailChartCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailChartCell"
    
    private let titleLabel = UILabel().then {
        $0.text = "PM 2.5"
        $0.font = Gabarito.regular.of(size: 14)
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "Unhealthy"
        $0.font = Gabarito.bold.of(size: 14)
        $0.textColor = .black
    }
    
    private let valueLabel = UILabel().then {
        $0.font = BagelFatOne.regular.of(size: 20)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let valueBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.99, green: 0.76, blue: 0.76, alpha: 1.0)
        $0.layer.cornerRadius = 30
    }
    
    private let chartView = LineChartView().then {
        $0.chartDescription.enabled = false
        $0.legend.enabled = false
        $0.rightAxis.enabled = false
        $0.leftAxis.enabled = false
        $0.xAxis.drawAxisLineEnabled = false
        $0.xAxis.labelPosition = .bottom
        $0.xAxis.drawGridLinesEnabled = false
        $0.xAxis.labelTextColor = .black
        $0.xAxis.labelFont = UIFont.systemFont(ofSize: 14)
        $0.extraLeftOffset = 18
        $0.extraRightOffset = 18
        $0.extraTopOffset = 18
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillEqually
    }
    
    private let separator = UIView().then {
        $0.backgroundColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
        backgroundColor = .white.withAlphaComponent(0.4)
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(valueBackgroundView)
        valueBackgroundView.addSubview(valueLabel)
        contentView.addSubview(chartView)
        contentView.addSubview(separator)
        contentView.addSubview(labelStackView)
        
        let days = getDaysOfWeek()
        for i in days {
            let label = UILabel().then {
                $0.text = i
                $0.font = i == "Today" ? Gabarito.bold.of(size: 14) : Gabarito.regular.of(size: 14)
                $0.textColor = i == "Today" ? .black : .black.withAlphaComponent(0.4)
                $0.textAlignment = .center
            }
            labelStackView.addArrangedSubview(label)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(18)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(18)
        }
        
        valueBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
            $0.width.height.equalTo(60)
        }
        
        valueLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(valueBackgroundView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(1)
        }
        
        chartView.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().offset(-18)
        }
    }
    
    func configure(with pollutant: [Pollutant], title: String) {
        print(pollutant)
        // 예제 데이터를 설정합니다.
        valueLabel.text = "\(pollutant[0].avg)"
        
        if title == "PM10" {
            titleLabel.text = "PM 10"
            if pollutant[0].avg <= 30 {
                valueBackgroundView.backgroundColor = UIColor(named: "good") ?? .systemGreen
                subtitleLabel.text = "Good"
            } else if pollutant[0].avg <= 50 {
                valueBackgroundView.backgroundColor = UIColor(named: "normal") ?? .systemBlue
                subtitleLabel.text = "Normal"
            } else {
                valueBackgroundView.backgroundColor = UIColor(named: "bad") ?? .systemRed
                subtitleLabel.text = "Unhealthy"
            }
            
        } else {
            titleLabel.text = "PM 2.5"
            if pollutant[0].avg <= 20 {
                valueBackgroundView.backgroundColor = UIColor(named: "good") ?? .systemGreen
                subtitleLabel.text = "Good"
            } else if pollutant[0].avg <= 25 {
                valueBackgroundView.backgroundColor = UIColor(named: "normal") ?? .systemBlue
                subtitleLabel.text = "Normal"
            } else {
                valueBackgroundView.backgroundColor = UIColor(named: "bad") ?? .systemRed
                subtitleLabel.text = "Unhealthy"
            }
        }
        
        let entries = (0..<7).map { i -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: Double(pollutant[i].avg))
        }
        
        let dataSet = LineChartDataSet(entries: entries, label: title)
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4
        // 데이터 포인트별로 색상을 다르게 설정
        dataSet.circleColors = entries.map { entry -> NSUIColor in
            if title == "PM10" {
                if entry.y <= 30 {
                    return UIColor(named: "good") ?? .systemGreen
                } else if entry.y <= 50 {
                    return UIColor(named: "normal") ?? .systemBlue
                } else {
                    return UIColor(named: "bad") ?? .systemRed
                }
            } else {
                if entry.y <= 20 {
                    return UIColor(named: "good") ?? .systemGreen
                } else if entry.y <= 25 {
                    return UIColor(named: "normal") ?? .systemBlue
                } else {
                    return UIColor(named: "bad") ?? .systemRed
                }
            }
        }
        dataSet.lineWidth = 1
        dataSet.setColor(.lightGray)
        dataSet.fillColor = .clear
        dataSet.drawFilledEnabled = true
        
        dataSet.drawValuesEnabled = true  // 데이터 포인트 값 표시
        dataSet.valueFont = GlacialIndifference.regular.of(size: 12)  // 데이터 포인트 값의 폰트 크기 설정
        dataSet.valueTextColor = .black  // 데이터 포인트 값의 텍스트 색상 설정
        
        chartView.data = LineChartData(dataSet: dataSet)
        // xAxis에 요일 레이블 설정
        chartView.xAxis.drawLabelsEnabled = false
    }
    
    private func getDaysOfWeek() -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "E"
        
        let today = Date()
        var days = [String]()
        
        for i in 0..<7 {
            if i == 0 {
                days.append("Today")
            } else {
                let day = Calendar.current.date(byAdding: .day, value: i, to: today)!
                days.append(formatter.string(from: day))
            }
        }
        
        return days
    }
}
