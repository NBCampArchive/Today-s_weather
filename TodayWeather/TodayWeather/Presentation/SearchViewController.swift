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
    
    private var localSearch: MKLocalSearch? = nil {
        willSet {
            localSearch?.cancel()
        }
    }
    
    private var searchRecent : [String] = []
    private var selectWeather = [CurrentResponseModel]()
    var longitude: Double = 126.978 {
        didSet {
            callAPIs()
        }
    }
    
    var latitude: Double = 37.5665
    
    let searchBar = UISearchBar()
    let border = CALayer()
    let width = CGFloat(2.0)
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
        callAPIs()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        setupSearchCompleter()
        setupLayout()
        setupSearch()
    }
    
    // MARK: - 금일 날씨 API 호출, view background 설정
    func callAPIs(){
        WeatherAPIManager.shared.getCurrentWeatherData(latitude: self.latitude, longitude: self.longitude) {[weak self] result in
            switch result{
            case .success(let data):
                self?.selectWeather.append(data)
                CurrentWeather.weather = "rain"
                self?.view.backgroundColor = CurrentWeather.shared.weatherColor()
                self?.selectTableView.insertRows(at: [IndexPath(row: (self?.selectWeather.count ?? 0) - 1, section: 0)], with: .automatic)
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
        selectTableView.separatorStyle = .none
        selectTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
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
        searchBar.setImage(UIImage(named: "searchUnselected"), for: .search, state: .normal)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.borderStyle = .none
            textfield.snp.makeConstraints {
                $0.top.equalToSuperview().offset(4)
                $0.leading.equalToSuperview().offset(20)
                $0.trailing.equalToSuperview().offset(-20)
                $0.height.equalTo(40)
            }
            if let clearButton = textfield.value(forKey: "clearButton") as? UIButton {
                clearButton.isHidden = true
                let customView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                
                // Create the button and add it to the custom view
                let customButton = UIButton(type: .custom)
                customButton.frame = customView.bounds
                customButton.setImage(UIImage(named: "largeX"), for: .normal)
                customButton.addTarget(self, action: #selector(clearView(_:)), for: .touchUpInside)
                customView.addSubview(customButton)
                
                // Set the custom view as the right view of the text field
                textfield.rightView = customView
                textfield.rightViewMode = .whileEditing
            }
            
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 16
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "어느지역 날씨가 궁금해요?", attributes: [NSAttributedString.Key.foregroundColor : UIColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), NSAttributedString.Key.font : Pretendard.medium.of(size: 11)])
            textfield.tintColor = UIColor(named: "yp-m")
            textfield.textColor = UIColor(named: "bk")
            textfield.font = Pretendard.bold.of(size: 11)
            textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.6)
        }
    }
    
    // 서치바 layout 변경
    func searchChanging() {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 0
            textfield.layer.cornerRadius = 16
            textfield.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            
            border.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            border.frame = CGRect(x: 13, y: textfield.frame.size.height - 5, width:  textfield.frame.size.width-26, height: 1)
            border.borderWidth = width
            textfield.layer.addSublayer(border)
            textfield.layer.masksToBounds = true
            
        }
    }
    
    func searchEnd() {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.clipsToBounds = true
            textfield.layer.cornerRadius = 16
            textfield.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner)
            border.frame = CGRect(x: -5, y: textfield.frame.size.height, width:  textfield.frame.size.width+10, height: textfield.frame.size.height)
            
        }
    }
}

// MARK: searchbar
extension SearchViewController : UISearchBarDelegate {
    
    //검색 시작시
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResults = []
        searchTableView.reloadData()
        searchLayout()
        print("뷰열기")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
    //위도 경도 찾기
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        searchLocal(using: searchRequest)
    }
    
    func searchLocal(using searchRequest: MKLocalSearch.Request) {
        searchRequest.resultTypes = .address  // 검색 유형
        
        localSearch = MKLocalSearch(request: searchRequest)
        
        localSearch?.start { [weak self] (response, error) in
            guard error == nil else { return }
            
            guard let place = response?.mapItems[0] else { return }
            self?.latitude = Double(place.placemark.coordinate.latitude)
            self?.longitude = Double(place.placemark.coordinate.longitude)
            
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
        if tableView == selectTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTableViewCell.Identifier, for: indexPath) as? SelectedTableViewCell
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.tempLbl.text = String(Int(selectWeather[indexPath.row].main.temp)) + "°C"
            cell.locLbl.text = selectWeather[indexPath.row].name
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
                cell.backgroundColor =  #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1).withAlphaComponent(0.6)
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
                cell.cancelBtn.isHidden = true
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
            return 115
        }else {
            return 26.5
        }
        
    }
    
    //셀 선택
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectTableView {
            tableView.deselectRow(at: indexPath, animated: true)
            CurrentWeather.weather = selectWeather[indexPath.row].weather[0].description
            view.backgroundColor = CurrentWeather.shared.weatherColor()
            
        }else {
            //검색중 셀선택시
            if indexPath.section == 0 {
                if searchResults.isEmpty == true {
                    searchBar.text = searchRecent[indexPath.row]
                    searchCompleter.queryFragment = searchRecent[indexPath.row]
                }else {
                    search(for: searchResults[indexPath.row])
                    searchEnd()
                    visualEffectView.removeFromSuperview()
                    searchTableView.removeFromSuperview()
                    searchBar.resignFirstResponder()
                    searchRecent.insert(searchResults[indexPath.row].title, at: 0)
                    
                    searchBar.text = ""
                }
            }else {
                searchBar.text = searchRecent[indexPath.row]
                searchCompleter.queryFragment = searchRecent[indexPath.row]
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == selectTableView {
            if indexPath.row == 0 {
                return false
            }else {
                return true
            }
        }else {
            return false
        }
    }
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

extension SearchViewController : delDelegate{
    func delDelegate(row: Int) {
        searchRecent.remove(at: row)
        searchTableView.reloadData()
    }
    
    @objc func clearView(_ sender: UIButton) {
        searchEnd()
        searchBar.text = ""
        visualEffectView.removeFromSuperview()
        searchTableView.removeFromSuperview()
        searchBar.resignFirstResponder()
    }
}
