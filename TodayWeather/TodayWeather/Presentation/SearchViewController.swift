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
import CoreLocation

class SearchViewController : UIViewController{
    private let searchView = SearchView()
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    private var localSearch: MKLocalSearch? = nil {
        willSet {
            localSearch?.cancel()
        }
    }
    
    private var searchRecent : [String] = []
    private var selectWeather = [CurrentResponseModel]()
    var longitude: Double = 126.978
    
    var latitude: Double = 37.5665
    var localtitle : [String] = ["Seoul"]
    
    
    // MARK: Life Cycle
    override func loadView() {
        view = searchView
    }
    override func viewWillAppear(_ animated: Bool) {
        callAPIs()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchView.searchBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchView.selectTableView.delegate = self
        searchView.selectTableView.dataSource = self
        searchView.searchTableView.delegate = self
        searchView.searchTableView.dataSource = self
        searchView.searchBar.delegate = self
        searchView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.Identifier)
        searchView.selectTableView.register(SelectedTableViewCell.self, forCellReuseIdentifier: SelectedTableViewCell.Identifier)
        setupSearchCompleter()
        searchView.setupSearch()
        
    }
    
    // MARK: - 금일 날씨 API 호출, view background 설정
    func callAPIs(){
        WeatherAPIManager.shared.getCurrentWeatherData(latitude: self.latitude, longitude: self.longitude) {[weak self] result in
            switch result{
            case .success(let data):
                self?.selectWeather.append(data)
                CurrentWeather.weather = "rain"
                self?.view.backgroundColor = CurrentWeather.shared.weatherColor()
                self?.searchView.selectTableView.insertRows(at: [IndexPath(row: (self?.selectWeather.count ?? 0) - 1, section: 0)], with: .automatic)
            case .failure(let error):
                print("GetCurrentWeatherData Failure \(error)")
            }
        }
    }
}

// MARK: searchbar
extension SearchViewController : UISearchBarDelegate {
    
    //검색 시작시
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResults = []
        searchView.searchTableView.reloadData()
        searchView.searchLayout()
        searchView.searchBar.setImage(UIImage(named: "searchSelected"), for: .search, state: .normal)
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.8)
        }
        print("뷰열기")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchRecent.insert(text , at: 0)
        }
        searchView.searchTableView.reloadData()
        print(searchRecent)
        print("뷰닫기")
    }
    
    //검색 중
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchText를 queryFragment로 넘겨준다.
        if searchText == "" {
            if searchRecent.isEmpty == true {
                searchView.searchEnd()
                searchView.searchBar.setImage(UIImage(named: "searchSelected"), for: .search, state: .normal)
            }
        }else {
            searchCompleter.queryFragment = searchText
        }
        
    }
    //위도 경도 찾기
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        searchLocal(using: searchRequest)
    }
    
    func searchLocal(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .address  // 검색 유형
        searchRequest.naturalLanguageQuery = "en"
        localSearch = MKLocalSearch(request: searchRequest)
        
        localSearch?.start { [weak self] (response, error) in
            guard error == nil else { return }
            
            guard let place = response?.mapItems[0] else { return }
            self?.latitude = Double(place.placemark.coordinate.latitude)
            self?.longitude = Double(place.placemark.coordinate.longitude)
//            self?.localtitle.append(place.name ?? "")
            self?.reverseGeocode(latitude: self?.latitude ?? 0, longitude: self?.longitude ?? 0)
        }
    }
}

//MARK: tableView
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    // section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == searchView.selectTableView {
            return 1
        }else {
            if searchRecent.isEmpty == true || searchResults.isEmpty == true{
                return 1
            }
            return 2
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == searchView.searchTableView {
            if section == 0 && searchRecent.isEmpty == false && searchResults.isEmpty == false{
                let footerView = UIView()
                footerView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.8)
                
                // 구분선 추가
                let separatorLine = UIView()
                separatorLine.backgroundColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.16)
                footerView.addSubview(separatorLine)
                
                separatorLine.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(13)
                    $0.top.equalToSuperview()
                    $0.height.equalTo(0.5)
                }
                return footerView
            }
            
        }
        return UIView()
    }
        
        // 섹션 푸터 높이 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5 // 원하는 높이로 설정
    }
    // row 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchView.selectTableView {
            return selectWeather.count
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
        if tableView == searchView.selectTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTableViewCell.Identifier, for: indexPath) as? SelectedTableViewCell
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.tempLbl.text = String(Int(selectWeather[indexPath.row].main.temp)) + "°C"
            cell.locLbl.text = localtitle[indexPath.row]
            print(selectWeather[indexPath.row].coord.lat, selectWeather[indexPath.row].coord.lon)
            cell.weatherImage.image = CurrentWeather.shared.weatherImage(weather: selectWeather[indexPath.row].weather[0].description)
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.Identifier, for: indexPath) as? SearchTableViewCell
            else { return UITableViewCell() }
            cell.locLbl.attributedText = nil
            if searchResults.isEmpty == true || indexPath.section == 1{
                cell.delegate = self
                cell.cancelBtn.isHidden = false
                cell.locLbl.text = searchRecent[indexPath.row]
                cell.locLbl.textColor = #colorLiteral(red: 0.3882352941, green: 0.3882352941, blue: 0.3882352941, alpha: 1)
                cell.backgroundColor =  #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1).withAlphaComponent(0.8)
                cell.selectionStyle = .none
                cell.clipsToBounds = true
                if indexPath.row == searchRecent.count - 1{
                    cell.layer.cornerRadius = 16
                    cell.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
                }else {
                    cell.layer.cornerRadius = 0
                }
                searchView.searchChanging()
            }else {
                cell.cancelBtn.isHidden = true
                cell.locLbl.text = searchResults[indexPath.row].title
                cell.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.8)
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
                if let highlightText = searchView.searchBar.text {
                    cell.locLbl.setHighlighted(searchResults[indexPath.row].title, with: highlightText)
                }
            }
            return cell
        }
        
    }
    
    //셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchView.selectTableView {
            return 115
        }else {
            return 26.5
        }
        
    }
    
    //셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchView.selectTableView {
            tableView.deselectRow(at: indexPath, animated: true)
            CurrentWeather.weather = selectWeather[indexPath.row].weather[0].description
            view.backgroundColor = CurrentWeather.shared.weatherColor()
            
        }else {
            //검색중 셀선택시
            if indexPath.section == 0 {
                if searchResults.isEmpty == true {
                    searchView.searchBar.text = searchRecent[indexPath.row]
                    searchCompleter.queryFragment = searchRecent[indexPath.row]
                }else {
                    search(for: searchResults[indexPath.row])
                    searchView.searchEnd()
                    searchView.visualEffectView.removeFromSuperview()
                    searchView.searchTableView.removeFromSuperview()
                    searchView.searchBar.resignFirstResponder()
                    searchRecent.insert(searchResults[indexPath.row].title, at: 0)
                    searchView.searchBar.setImage(UIImage(named: "searchUnselected"), for: .search, state: .normal)
                    if let textfield = searchView.searchBar.value(forKey: "searchField") as? UITextField {
                        textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
                    }
                    searchView.searchBar.text = ""
                }
            }else {
                searchView.searchBar.text = searchRecent[indexPath.row]
                searchCompleter.queryFragment = searchRecent[indexPath.row]
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == searchView.selectTableView {
            if indexPath.row == 0 {
                return false
            }else {
                return true
            }
        }else {
            return false
        }
    }
    
    //셀 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let customView = UIView()
        customView.backgroundColor = .red
        customView.bounds = CGRect(x: 0, y: 0, width: 80, height: 123)
        customView.layer.cornerRadius = 16// 높이를 조정

                // 커스텀 뷰에 라벨 추가
        if let trashImage = UIImage(systemName: "trash.fill") {
            let imageView = UIImageView(image: trashImage)
                    imageView.tintColor = .white
            let iconSize = 30
            imageView.frame = CGRect(x: (Int(customView.frame.width) - iconSize) / 2, y: (Int(customView.frame.height) - iconSize) / 2, width: iconSize, height: iconSize)
            customView.addSubview(imageView)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.selectWeather.remove(at: indexPath.row)
            self.localtitle.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        deleteAction.backgroundColor = view.backgroundColor
        deleteAction.image = UIGraphicsImageRenderer(size: customView.bounds.size).image { _ in
                    customView.layer.render(in: UIGraphicsGetCurrentContext()!)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

//MARK: Search Completer
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
            searchView.searchEnd()
        }else {
            searchView.searchChanging()
        }
        searchView.searchTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        searchView.searchEnd()
        // 에러 확인
        print(error.localizedDescription)
    }
}

extension SearchViewController : delDelegate{
    func delDelegate(row: Int) {
        searchView.searchEnd()
        searchRecent.remove(at: row)
        searchView.searchTableView.reloadData()
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func reverseGeocode(latitude: Double, longitude: Double) {
           let location = CLLocation(latitude: latitude, longitude: longitude)
            let geocoder: CLGeocoder = CLGeocoder()
            let local: Locale = Locale(identifier: "en-US")
           geocoder.reverseGeocodeLocation(location, preferredLocale: local) { (placemarks, error) in
               if let error = error {
                   print("Reverse geocoding error: \(error.localizedDescription)")
                   return
               }
               
               guard let placemark = placemarks?.first else {
                   print("No placemark found")
                   return
               }
               
               let name = (placemark.locality ?? "") + ", " + (placemark.country ?? "")
               
               // 주소 정보 가져오기
               self.localtitle.append(name)
               self.callAPIs()
           }
       }
}

