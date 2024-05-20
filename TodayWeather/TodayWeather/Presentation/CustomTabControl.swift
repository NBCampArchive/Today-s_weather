//
//  DustTabViewController.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/16/24.
//

import UIKit
import SnapKit
import Then

class CustomTabControl: UIViewController {
    
    private var segmentControl: UISegmentedControl!
    private let containerView = UIView()
    
    let segmentDivider = UIView().then {
        $0.backgroundColor = .black
    }
    
    let segmentBackgroundDivider = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    private var currentViewController: UIViewController?
    private var viewControllers: [UIViewController]
    private var segmentTitles: [String]
    
    // 이니셜라이저에서 외부에서 뷰 컨트롤러와 탭 타이틀을 전달받습니다.
    init(titles: [String], viewControllers: [UIViewController]) {
        self.segmentTitles = titles
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        // 세그먼트 컨트롤 초기화 및 설정
        segmentControl = UISegmentedControl(items: segmentTitles).then {
            $0.selectedSegmentIndex = 0
            
            // 세그먼트 구분선을 명확하게 설정
            $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
            $0.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
            $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            
            // 선택되지 않은 상태와 선택된 상태의 텍스트 속성 설정
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 17, weight: .bold)
            ]
            $0.setTitleTextAttributes(normalAttributes, for: .normal)
            $0.setTitleTextAttributes(selectedAttributes, for: .selected)
            $0.tintColor = .clear
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        displayCurrentTab(0)
    }
   
    private func setupViews() {
        view.addSubview(segmentControl)
        view.addSubview(segmentDivider)
        view.addSubview(segmentBackgroundDivider)
        view.addSubview(containerView)
        
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        segmentDivider.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.leading.equalTo(segmentControl)
            $0.width.equalTo(segmentControl).dividedBy(segmentControl.numberOfSegments)
            $0.height.equalTo(2)
        }
        
        segmentBackgroundDivider.snp.makeConstraints{
            $0.top.equalTo(segmentControl.snp.bottom).offset(2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(segmentBackgroundDivider.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        displayCurrentTab(sender.selectedSegmentIndex)
        let selectedSegmentWidth = sender.bounds.width / CGFloat(sender.numberOfSegments)
        let selectedSegmentOriginX = selectedSegmentWidth * CGFloat(sender.selectedSegmentIndex)
        
        segmentDivider.snp.remakeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.height.equalTo(2)
            $0.width.equalTo(selectedSegmentWidth) // 선택된 세그먼트의 너비로 설정
            $0.leading.equalTo(segmentControl.snp.leading).offset(selectedSegmentOriginX) // 선택된 세그먼트의 leading에 맞춤
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded() // 제약 조건 변경 후 레이아웃 업데이트
        }
    }
    
    private func displayCurrentTab(_ index: Int) {
        let newViewController = viewControllers[index]
        
        addChild(newViewController)
        newViewController.view.frame = containerView.bounds
        containerView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
        
        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        
        currentViewController = newViewController
    }
}
