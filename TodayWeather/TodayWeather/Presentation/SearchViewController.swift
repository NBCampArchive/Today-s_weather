//
//  SearchViewController.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/14/24.
//

import UIKit
import SnapKit
import Then
import MapKit

class SearchViewController : UIViewController{
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchReseults = [MKLocalSearchCompletion]()
    
    let searchBar = UISearchBar()
    let selectTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    let searchTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9607843137, blue: 0.9215686275, alpha: 1)
        self.navigationItem.titleView = searchBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        setupLayout()
        
        setupSearch()
    }
    
    func setupLayout() {
        selectTableView.delegate = self
        selectTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        view.addSubview(selectTableView)
        
        selectTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    func searchLayout() {
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        view.addSubview(searchTableView)
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-12)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    func setupSearch() {
//        searchBar.backgroundColor = .white
        searchBar.delegate = self
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 16
        searchBar.setImage(UIImage(named: "search_back"), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: "search_cancel"), for: .clear, state: .normal)
                
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.snp.makeConstraints {
                $0.top.equalToSuperview().offset(4)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(40)
            }
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "어느지역 날씨가 궁금해요?", attributes: [NSAttributedString.Key.foregroundColor : UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)])
                textfield.tintColor = UIColor(named: "yp-m")
                textfield.textColor = UIColor(named: "bk")
//                textfield.font = UIFont.NotoSansKR(type: .Regular, size: 15)
            textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
//                if let leftView = textfield.leftView as? UIImageView {
//                        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
//                    }
//                    
//                if let rightView = textfield.rightView as? UIImageView {
//                        rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
//                    }
                    
            }
    }
}

// MARK: searchbar
extension SearchViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchLayout()
        print("뷰열기")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        visualEffectView.removeFromSuperview()
        searchTableView.removeFromSuperview()
        print("뷰닫기")
    }
}

//MARK: tableView
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectTableView {
            return 0
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == selectTableView {
            return UITableViewCell()
        }else {
            return UITableViewCell()
        }
    }
    
    
}
