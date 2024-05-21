//
//  DustyViewController.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/14/24.
//

import UIKit
import SnapKit
import Then

class DustyViewController: UIViewController{
    
    var backgroundColor: UIColor?
    
    let dotAnimationView = DotAnimationView().then{
        $0.layer.cornerRadius = 140
        $0.layer.masksToBounds = true
    }
    
    let dayLabel = UILabel().then {
        $0.text = "August 8 . Friday"
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .black
    }
    
    let locationCityLabel = UILabel().then {
        $0.text = "Seoul"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = .black
        $0.backgroundColor = .clear
    }
    
    let locationCountryLabel = UILabel().then {
        $0.text = "Korea"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .black
    }
    
    let locationImageView = UIImageView().then {
        $0.image = UIImage(systemName: "location.circle.fill")
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
    }
    
    let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    let locationLabelStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .firstBaseline
    }
    
    let optionSegment = SegmentControlView()
    
    var longitude: Double = 0.0
    
    var latitude: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(named: "sunBackground")
//        self.backgroundColor = UIColor(named: "dustFineColor")
        setupLayout()
        startDotAnimation()
        LocationManager.shared.requestLocation { location in
            guard let location = location else { return }
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            DispatchQueue.main.async {
                self.fetchDustyData()
            }
            print("Latitude: \(self.latitude)")
            print("Longitude: \(self.longitude)")
        }
        
        optionSegment.selectedColor = dotAnimationView.backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startDotAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopDotAnimation()
    }
    
    private func startDotAnimation() {
        dotAnimationView.startAnimatingDots()
    }
    
    private func stopDotAnimation() {
        dotAnimationView.stopAnimatingDots()
    }
    
    func setupLayout() {
        view.addSubview(dotAnimationView)
        view.addSubview(dayLabel)
        view.addSubview(locationStackView)
        locationStackView.addArrangedSubview(locationImageView)
        locationStackView.addArrangedSubview(locationLabelStackView)
        locationLabelStackView.addArrangedSubview(locationCityLabel)
        locationLabelStackView.addArrangedSubview(locationCountryLabel)
        view.addSubview(optionSegment)
        
        dayLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        locationStackView.snp.makeConstraints{
            $0.top.equalTo(dayLabel.snp.bottom).offset(4)
            $0.leading.equalTo(dayLabel)
        }

        locationImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
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
    
    func fetchDustyData() {
        DustAPIManager.shared.getDustData(latitude: self.latitude, longitude: self.longitude) { result in
            switch result{
            case .success(let data):
                print("getDustData Success: \(data.data.city.name)")
                let city = data.data.city.name.components(separatedBy: ", ")
                print("City : \(city[1])")
                DispatchQueue.main.async{
                    self.dayLabel.text = data.data.time.s.components(separatedBy: " ")[0]
                    self.locationCityLabel.text = city[1]
                    self.locationCountryLabel.text = city[0]
                    self.dotAnimationView.aqiLabel.text = String(data.data.aqi)
                }
            case .failure(let error):
                print("getDustData Failure \(error)")
            }
        }
    }
    
}
