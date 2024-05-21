//
//  DetailAqiViewController.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/20/24.
//

import UIKit
import SnapKit
import Then

class DetailAqiViewController: UIViewController {
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.93, alpha: 1.0)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupChartViews()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.width.equalToSuperview().offset(-40)
        }
    }
    
    private func setupChartViews() {
        for index in 0..<2 {
            let chartView = ChartView()
            chartView.configure(index: index)
            chartView.snp.makeConstraints {
                $0.height.equalTo(240)
            }
            stackView.addArrangedSubview(chartView)
        }
    }
}

