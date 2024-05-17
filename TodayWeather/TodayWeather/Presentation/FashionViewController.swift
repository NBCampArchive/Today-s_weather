//
//  FashionViewController.swift
//  TodayWeather
//
//  Created by t2023-m0074 on 5/16/24.
//

import UIKit

class FashionViewController: UIViewController {
    
    private let tableView = UITableView()
   

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.configureUI()
        self.view.backgroundColor = .sunnyBackground
        tableView.sectionIndexBackgroundColor = UIColor.sunnyBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FashionTableViewCell.self, forCellReuseIdentifier: FashionTableViewCell.identifier)
        
    }
    
    func configureUI() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(400)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(80)
        }
        
    }

}
extension FashionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FashionTableViewCell.identifier, for: indexPath) as! FashionTableViewCell
        cell.fashionLabel.text = "나시티,반바지,반팔"
        cell.subLabel.text = "오후"
        cell.tmpLabel.text = "21"
        return cell
    }

}
extension FashionViewController: UITableViewDelegate {
    
}
