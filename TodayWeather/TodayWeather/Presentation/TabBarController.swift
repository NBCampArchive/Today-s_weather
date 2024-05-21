//
//  TabBarController.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/21/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage() // add this if you want remove tabBar separator
        tabBar.barTintColor = .clear
        tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)// TabBar Item 이 선택되었을때의 색
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1) // TabBar Item 의 기본 색
        tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.2) // here is your tabBar color
        tabBar.layer.backgroundColor = UIColor.clear.cgColor


        let blurEffect = UIBlurEffect(style: .light) // here you can change blur style
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = .flexibleWidth
        tabBar.insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setUpTabBar()
    }
    private func setUpTabBar() {
        let firstViewController = WeatherViewController()// TabBar Item 의 이름
        firstViewController.tabBarItem.title = "날씨"
        firstViewController.tabBarItem.image = UIImage(named: "weatherSelected")
        
        let secondViewController = UINavigationController(rootViewController: SearchViewController())
        secondViewController.tabBarItem.title = "검색"
        secondViewController.tabBarItem.image = UIImage(named: "searchSelected")
        
        let ThirdViewController = WeatherViewController()// TabBar Item 의 이름
        ThirdViewController.tabBarItem.title = "미세먼지"
        ThirdViewController.tabBarItem.image = UIImage(named: "blizzardSelected")
        
        let fourthViewController = UINavigationController(rootViewController: SearchViewController())
        fourthViewController.tabBarItem.title = "추천"
        fourthViewController.tabBarItem.image = UIImage(named: "recommendationSelected")
        
        viewControllers = [firstViewController,
                           secondViewController,ThirdViewController,fourthViewController]
    }
}
