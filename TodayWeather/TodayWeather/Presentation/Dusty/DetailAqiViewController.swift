//
//  DetailAqiViewController.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/20/24.
//

import UIKit

class DetailAqiViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var iaqiData: [AQIValue?] = []
    var pm10PollutantData: [Pollutant] = []
    var pm25PollutantData: [Pollutant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchData()
    }
    
    private func configureCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register cells
        collectionView.register(DetailCardCell.self, forCellWithReuseIdentifier: DetailCardCell.reuseIdentifier)
        collectionView.register(DetailChartCell.self, forCellWithReuseIdentifier: DetailChartCell.reuseIdentifier)
        
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize: NSCollectionLayoutSize
            let group: NSCollectionLayoutGroup
            
            if sectionIndex == 0 || sectionIndex == 1 {
                // Sections with DetailChartCell
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(240))
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            } else {
                // Section with DetailCardCell in a 2x2 grid
                let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerGroupSize, subitems: [item])
                innerGroup.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 4.5, bottom: 8, trailing: 4.5)  // 내부 그룹 간의 간격 설정
                
                let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [innerGroup, innerGroup])
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(130))
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [outerGroup, outerGroup])
            }
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            
            return section
        }
    }
    
    private func fetchData() {
        let latitude = 37.7749
        let longitude = -122.4194
        
        DustAPIManager.shared.getDustData(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let data):
                print(data.data.iaqi)
                self?.iaqiData = [
                    data.data.iaqi.o3 ?? AQIValue(v: 0.0),//오존
                    data.data.iaqi.no2 ?? AQIValue(v: 0.0),//이산화질소
                    data.data.iaqi.co ?? AQIValue(v: 0.0),//일산화탄소
                    data.data.iaqi.so2 ?? AQIValue(v: 0.0)//아황산가스
                ]
                
                self?.pm10PollutantData = data.data.forecast.daily.pm10
                self?.pm25PollutantData = data.data.forecast.daily.pm25
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}

extension DetailAqiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailChartCell.reuseIdentifier, for: indexPath) as! DetailChartCell
            if pm10PollutantData.count > 0 {
                let pollutant = pm10PollutantData
                cell.configure(with: pollutant, title: "PM10")
                
            }
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailChartCell.reuseIdentifier, for: indexPath) as! DetailChartCell
            if pm25PollutantData.count > 0 {
                let pollutant = pm25PollutantData
                cell.configure(with: pollutant, title: "PM2.5")
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCardCell.reuseIdentifier, for: indexPath) as! DetailCardCell
            if iaqiData.count > 0 {
                let title = ["O3", "NO2", "CO", "SO2"]
                if let iaqiData = iaqiData[indexPath.item] {
                    cell.configure(with: iaqiData, title: title[indexPath.item])
               }
            }
            return cell
        }
    }
}
