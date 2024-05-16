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
    private var searchResults = [MKLocalSearchCompletion]()
    private var searchRecent : [String] = []
    private var weather = [CurrentResponseModel]()
    
    var longitude: Double = 0 {
        didSet {
            callAPIs()
        }
    }
    
    var latitude: Double = 0
    
    let searchBar = UISearchBar()
    
    let selectTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .clear
    }
    
    let searchTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        LocationManager.shared.requestLocation { location in
            guard let location = location else { return }
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9882352941, green: 0.9607843137, blue: 0.9215686275, alpha: 1)
        self.navigationItem.titleView = searchBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        setupSearchCompleter()
        setupLayout()
        setupSearch()
    }
    // MARK: - 금일 날씨 API 호출
    func callAPIs(){
        WeatherAPIManager.shared.getCurrentWeatherData(latitude: self.latitude, longitude: self.longitude) { result in
            switch result{
            case .success(let data):
                self.weather.append(data)
                self.selectTableView.reloadData()
            case .failure(let error):
                print("GetCurrentWeatherData Failure \(error)")
            }
        }
    }
    // MARK: Layout
    func setupLayout() {
        selectTableView.delegate = self
        selectTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.Identifier)
        selectTableView.register(SelectedTableViewCell.self, forCellReuseIdentifier: SelectedTableViewCell.Identifier)
        
        view.addSubview(selectTableView)
        
        searchTableView.separatorStyle = .none
        selectTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    //searchbar 클릭시 layout
    func searchLayout() {
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        view.addSubview(searchTableView)
        searchTableView.contentInset = .zero
        searchTableView.contentInsetAdjustmentBehavior = .never
        searchBar.layer.cornerRadius = 0 // 모서리를 직각으로 만듭니다.
               searchBar.layer.masksToBounds = true
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-12)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    //searchbar layout
    func setupSearch() {
        searchBar.delegate = self
        searchBar.setImage(UIImage(named: "search_back"), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: "search_cancel"), for: .clear, state: .normal)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.borderStyle = .none
            textfield.snp.makeConstraints {
                $0.top.equalToSuperview().offset(4)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(40)
            }
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 16
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "어느지역 날씨가 궁금해요?", attributes: [NSAttributedString.Key.foregroundColor : UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)])
            textfield.tintColor = UIColor(named: "yp-m")
            textfield.textColor = UIColor(named: "bk")
//                textfield.font = UIFont.NotoSansKR(type: .Regular, size: 15)
            textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
                if let leftView = textfield.leftView as? UIImageView {
                        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                    }
                    
                if let rightView = textfield.rightView as? UIImageView {
                        rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                    }
                    
            }
    }
    
    // 서치바 layout 변경
    func searchChanging() {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 0
            textfield.layer.cornerRadius = 16
            textfield.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }
    
    func searchEnd() {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 16
            textfield.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }
}

// MARK: searchbar
extension SearchViewController : UISearchBarDelegate {
    //검색 시작시
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchLayout()
        print("뷰열기")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        visualEffectView.removeFromSuperview()
//        searchTableView.removeFromSuperview()
        if let text = searchBar.text {
            searchRecent.insert(text , at: 0)
        }
        searchTableView.reloadData()
        print(searchRecent)
        print("뷰닫기")
    }
    
    //검색 중
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchText를 queryFragment로 넘겨준다.
        if searchText == "" {
            if searchRecent.isEmpty == true {
                searchEnd()
            }
        }else {
            searchCompleter.queryFragment = searchText
        }
        
    }
}

//MARK: tableView
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    // section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == selectTableView {
            return 1
        }else {
            if searchRecent.isEmpty == true || searchResults.isEmpty == true{
                return 1
            }
            return 2
        }
    }
    // row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectTableView {
            return weather.count
        }else {
            if searchResults.isEmpty == true || section == 1{
                return searchRecent.count
            } else {
                return searchResults.count
            }
            
        }
    }
    // cell 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == selectTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTableViewCell.Identifier, for: indexPath) as? SelectedTableViewCell
                    else { return UITableViewCell() }
            cell.tempLbl.text = String(weather[indexPath.row].main.temp)
            cell.locLbl.text = weather[indexPath.row].name
            return cell
        }else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.Identifier, for: indexPath) as? SearchTableViewCell
                    else { return UITableViewCell() }
            if searchResults.isEmpty == true || indexPath.section == 1{                
                cell.locLbl.text = searchRecent[indexPath.row]
                cell.locLbl.textColor = #colorLiteral(red: 0.3882352941, green: 0.3882352941, blue: 0.3882352941, alpha: 1)
                cell.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
                cell.selectionStyle = .none
                cell.clipsToBounds = true
                if indexPath.row == searchRecent.count - 1{
                    cell.layer.cornerRadius = 16
                    cell.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
                }else {
                    cell.layer.cornerRadius = 0
                }
                searchChanging()
            }else {
                cell.locLbl.text = searchResults[indexPath.row].title
                cell.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
                cell.selectionStyle = .none
                cell.clipsToBounds = true
                if searchRecent.isEmpty == true {
                    if indexPath.row == searchResults.count - 1{
                        cell.layer.cornerRadius = 16
                        cell.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
                    }else {
                        cell.layer.cornerRadius = 0
                    }
                }else {
                    cell.layer.cornerRadius = 0
                }
                if let highlightText = searchBar.text {
                    cell.locLbl.setHighlighted(searchResults[indexPath.row].title, with: highlightText)
                }
            }
            return cell
        }
        
    }
    //셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == selectTableView {
            return 99
        }else {
            return 26.5
        }
        
    }
    
    //셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if searchResults.isEmpty == true {
                searchBar.text = searchRecent[indexPath.row]
                searchCompleter.queryFragment = searchRecent[indexPath.row]
            }else {
                
            }
        }else {
            searchBar.text = searchRecent[indexPath.row]
            searchCompleter.queryFragment = searchRecent[indexPath.row]
        }
    }
    
}

extension SearchViewController : MKLocalSearchCompleterDelegate {
    
    func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    // 자동완성 완료 시에 결과를 받는 함수
        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            // completer.results를 통해 검색한 결과를 searchResults에 담아줍니다
            searchResults = completer.results
            if searchResults.count == 0 {
                searchEnd()
            }else {
                searchChanging()
            }
            searchTableView.reloadData()
        }
        
        func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
            searchEnd()
            // 에러 확인
            print(error.localizedDescription)
        }
}
