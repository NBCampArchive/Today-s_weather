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
    
    let dotAnimationView = DotAnimationView().then{
//        $0.backgroundColor = UIColor(named: "dustFineColor")
        $0.layer.cornerRadius = 130
        $0.layer.masksToBounds = true
    }
    
    let segmentedControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "Today", at: 0, animated: true)
        $0.insertSegment(withTitle: "Detail", at: 1, animated: true)
        $0.selectedSegmentIndex = 0
        
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        $0.layer.borderWidth = 0
        $0.layer.masksToBounds = true
        
        // Set text attributes
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
            
        ]
        $0.setTitleTextAttributes(normalAttributes, for: .normal)
        $0.setTitleTextAttributes(selectedAttributes, for: .selected)
        $0.tintColor = .clear
    }
    
    let segmentDivider = UIView().then {
        $0.backgroundColor = .white
    }
    
    let divider = UIView().then {
        $0.backgroundColor = .white
    }
    
    let dayLabel = UILabel().then {
        $0.text = "August 8 . Friday"
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .white
    }
    
    let locationLabel = UILabel().then {
        $0.text = "Seoul, Korea"
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .white
    }
    
    let locationImageView = UIImageView().then {
        $0.image = UIImage(systemName: "location.circle.fill")
        $0.tintColor = .white
    }
    
    let locationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "sunBackground")
        
        setupSegmentedControlControl()
        setupLayout()
    }
    
    func setupSegmentedControlControl(){
        segmentedControl.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
    }
    
    @objc func didChangeSegmentControl(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            dotAnimationView.backgroundColor = .gray
        case 1:
            dotAnimationView.backgroundColor = .yellow
        default:
            break
        }
        
        let selectedSegmentWidth = sender.bounds.width / CGFloat(sender.numberOfSegments)
        let selectedSegmentOriginX = selectedSegmentWidth * CGFloat(sender.selectedSegmentIndex)
        
        segmentDivider.snp.remakeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.height.equalTo(2)
            $0.width.equalTo(selectedSegmentWidth) // 선택된 세그먼트의 너비로 설정
            $0.leading.equalTo(segmentedControl.snp.leading).offset(selectedSegmentOriginX) // 선택된 세그먼트의 leading에 맞춤
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 제약 조건 변경 후 레이아웃 업데이트
        }
    }
    
    func setupLayout() {
        view.addSubview(segmentedControl)
        view.addSubview(segmentDivider)
        view.addSubview(dotAnimationView)
        view.addSubview(divider)
        view.addSubview(dayLabel)
        view.addSubview(locationStackView)
        locationStackView.addArrangedSubview(locationImageView)
        locationStackView.addArrangedSubview(locationLabel)
        
        segmentedControl.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        segmentDivider.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.equalTo(segmentedControl)
            $0.width.equalTo(segmentedControl).dividedBy(2)
            $0.height.equalTo(2)
        }
        
        dotAnimationView.snp.makeConstraints{
            $0.top.equalTo(segmentDivider.snp.bottom).offset(105)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(260)
        }
        
        divider.snp.makeConstraints{
            $0.top.equalTo(dotAnimationView.snp.bottom).offset(114)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(3)
        }
        
        dayLabel.snp.makeConstraints{
            $0.top.equalTo(divider.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        
        locationStackView.snp.makeConstraints{
            $0.top.equalTo(dayLabel.snp.bottom).offset(10)
            $0.leading.equalTo(dayLabel)
        }
    }
    
}
