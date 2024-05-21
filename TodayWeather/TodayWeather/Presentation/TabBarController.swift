//
//  TabBarController.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/21/24.
//

import UIKit

class TabBarController: UITabBarController {
    let border = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage() // add this if you want remove tabBar separator
        tabBar.barTintColor = .clear
        tabBar.tintColor = UIColor(named: "menu")// TabBar Item 이 선택되었을때의 색
        tabBar.unselectedItemTintColor = UIColor(named: "unselectedTab")// TabBar Item 의 기본 색
        tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.2) // here is your tabBar color
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        setUpBorder()
        setUpBlur()
        setUpTabBar()
    }
    private func setUpTabBar() {
        let firstViewController = CustomTabControl(titles: ["Today","5 days"], viewControllers: [WeatherViewController(),FiveDaysWeatherViewController()])// TabBar Item 의 이름
        firstViewController.tabBarItem.title = "날씨"
        firstViewController.tabBarItem.image = UIImage(named: "weatherSelected")
        
        let secondViewController = UINavigationController(rootViewController: SearchViewController())
        secondViewController.tabBarItem.title = "검색"
        secondViewController.tabBarItem.image = UIImage(named: "searchSelected")
        
        let ThirdViewController = CustomTabControl(titles: ["Today","Detail"], viewControllers: [DustyViewController(),DetailAqiViewController()])// TabBar Item 의 이름
        ThirdViewController.tabBarItem.title = "미세먼지"
        ThirdViewController.tabBarItem.image = UIImage(named: "blizzardSelected")
        
        let fourthViewController = CustomTabControl(titles: ["Menu","Clothes"], viewControllers: [FoodViewController(),DetailAqiViewController()])
        fourthViewController.tabBarItem.title = "추천"
        fourthViewController.tabBarItem.image = UIImage(named: "recommendationSelected")
        
        viewControllers = [firstViewController,
                           secondViewController,ThirdViewController,fourthViewController]
    }
    
    private func setUpBlur() {
        let blurEffect = UIBlurEffect(style: .light) // here you can change blur style
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = .flexibleWidth
        tabBar.insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpBorder() {
        border.borderColor = UIColor(named: "graph")?.cgColor
        border.frame = CGRect(x: 0, y: 0, width:  tabBar.frame.size.width, height: 1)
        border.borderWidth = tabBar.frame.size.width
        tabBar.layer.addSublayer(border)
        tabBar.layer.masksToBounds = true
    }
}
