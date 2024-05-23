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
import Combine

class SearchViewController : UIViewController{
    var cancellable = Set<AnyCancellable>()
    private let searchView = SearchView()
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    private var localSearch: MKLocalSearch? = nil {
        willSet {
            localSearch?.cancel()
        }
    }
    
    let CDM = CoreDataManager()
    private var searchRecent : [String] = []
    private var selectWeather = [CurrentResponseModel]()
    lazy var longitude : Double = WeatherDataManager.shared.weatherData?.coord.lon ?? 126.978
    lazy var latitude : Double = WeatherDataManager.shared.weatherData?.coord.lat ?? 37.5665
    var localtitle : [String] = []
    // MARK: - Life Cycle
    override func loadView() {
        view = searchView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherDataManager.shared.$weatherData
            .sink { [weak self] weatherData in
                guard let weatherData = weatherData else { return }
                CurrentWeather.id = weatherData.weather[0].id
                self?.view.backgroundColor = CurrentWeather.shared.weatherColor()
            }
            .store(in: &cancellable)
        callAPIs(locName: "My Location")
        for i in CDM.readData() {
            longitude = i.longitude
            latitude = i.latitude
            callAPIs(locName: i.locName)
        }
        self.navigationItem.titleView = searchView.searchBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchView.selectTableView.delegate = self
        searchView.selectTableView.dataSource = self
        searchView.searchTableView.delegate = self
        searchView.searchTableView.dataSource = self
        searchView.selectTableView.showsVerticalScrollIndicator = false
        searchView.searchBar.delegate = self
        searchView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.Identifier)
        searchView.selectTableView.register(SelectedTableViewCell.self, forCellReuseIdentifier: SelectedTableViewCell.Identifier)
        setupSearchCompleter()
        searchView.setupSearch()
    }
    
    // MARK: - 금일 날씨 API 호출, view background 설정
    func callAPIs(locName : String) {
        WeatherAPIManager.shared.getCurrentWeatherData(latitude: self.latitude, longitude: self.longitude)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("GetCurrentWeatherData Failure: \(error)")
                }
            }, receiveValue: { data in
                self.selectWeather.append(data)
                self.localtitle.append(locName)
                DispatchQueue.main.async {
                    self.searchView.selectTableView.reloadData()
                }
                print("GetCurrentWeatherData Success: \(data)")
            })
            .store(in: &cancellable)
    }
}

// MARK: - searchbar
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
            // 지역명 받아오는 api?
            CurrentWeather.shared.reverseGeocode(latitude: self!.latitude , longitude: self!.longitude, save: true) { data in
                switch data {
                case .success(let name) :
                    self?.callAPIs(locName: name[0] + ", " + name[1])
                case .failure(let error) :
                    print("Reverse geocoding error: \(error.localizedDescription)")
                }
            }
        }
    }
}

//MARK: - tableView
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    // section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == searchView.selectTableView {
            return 1
        } else {
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
        } else {
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
            cell.configureUI(weather: selectWeather[indexPath.row], title: localtitle[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.Identifier, for: indexPath) as? SearchTableViewCell
            else { return UITableViewCell() }
            cell.locLbl.attributedText = nil
            cell.delegate = self
            if searchResults.isEmpty == true || indexPath.section == 1{
                cell.configureRecentUI(title: searchRecent[indexPath.row], row: indexPath.row, count: searchRecent.count - 1)
                searchView.searchChanging()
            }else {
                cell.configureResultUI(title: searchResults[indexPath.row].title, row: indexPath.row, count: searchResults.count - 1, Recent: searchRecent.isEmpty)
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
        } else {
            if indexPath.section == 0 {
                if searchResults.isEmpty == false {
                    if searchRecent.isEmpty == true && searchResults.count - 1 == indexPath.row {
                        return 34.5
                    }else {
                        return 30.5
                    }
                }else {
                    if searchRecent.count - 1 == indexPath.row {
                        return 34
                    }else {
                        return 28
                    }
                }
            }else {
                if searchRecent.count - 1 == indexPath.row {
                    return 34
                }else {
                    return 28
                }
            }
        }
    }
    
    //셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchView.selectTableView {
            tableView.deselectRow(at: indexPath, animated: true)
            WeatherDataManager.shared.weatherData = selectWeather[indexPath.row]

            if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 0 // 두 번째 탭 선택
            }
        }else {
            //검색중 셀선택시
            if indexPath.section == 0 {
                if searchResults.isEmpty == true {
                    searchView.searchBar.text = searchRecent[indexPath.row]
                    searchCompleter.queryFragment = searchRecent[indexPath.row]
                } else {
                    search(for: searchResults[indexPath.row])
                    searchView.searchEnd()
                    searchView.border.removeFromSuperlayer()
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
            } else {
                searchView.searchBar.text = searchRecent[indexPath.row]
                searchCompleter.queryFragment = searchRecent[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == searchView.selectTableView {
            if indexPath.row == 0 {
                return false
            } else {
                return true
            }
        } else {
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
            self.CDM.deleteData(title: self.localtitle[indexPath.row])
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

//MARK: - Search Completer
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
        } else {
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
//MARK: - search xbutton delegate
extension SearchViewController : delDelegate{
    func delDelegate(row: Int) {
        if searchResults.isEmpty == true {
            searchView.searchEnd()
        }
        searchRecent.remove(at: row)
        searchView.searchTableView.reloadData()
    }
}
