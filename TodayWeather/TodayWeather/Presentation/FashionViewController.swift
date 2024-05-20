//
//  FashionViewController.swift
//  TodayWeather
//
//  Created by t2023-m0074 on 5/16/24.
//

import UIKit

class FashionViewController: UIViewController {
    
    private let tableView = UITableView()
    let tempLabel = UILabel()
    let tempImageView = UIImageView()
    let tempFont = UIFont(name: "BagelFatOne-Regular", size: 96)
    let tmpView = UIView()
    let dayLabel = UILabel()
    let dayFont = UIFont(name: "Gabarito-Bold", size: 17)
    let cityLabel = UILabel()
    let cityFont = UIFont(name: "Gabarito-SemiBold", size: 20)
    let nationLabel = UILabel()
    let nationFont = UIFont(name: "Gabarito-Medium", size: 10)
    let markImageView = UIImageView()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(tempLabel)
        view.addSubview(tmpView)
        view.addSubview(tempImageView)
        view.addSubview(nationLabel)
        view.addSubview(markImageView)
        configureUI()
        setupConstraints()
        self.view.backgroundColor = .sunnyBackground
        tableView.backgroundColor = .sunnyBackground
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FashionTableViewCell.self, forCellReuseIdentifier: FashionTableViewCell.identifier)
        
    }
    
    func configureUI() {
        tmpView.addSubview(markImageView)
        markImageView.image = UIImage(resource: .locationMark)
        view.addSubview(tmpView)
        tmpView.addSubview(nationLabel)
        nationLabel.font = nationFont
        nationLabel.text = "korea"
        tmpView.addSubview(tempImageView)
        tmpView.backgroundColor = .clear
        tmpView.addSubview(dayLabel)
        dayLabel.font = dayFont
        dayLabel.text = "friday August 8"
        tmpView.addSubview(cityLabel)
        cityLabel.font = cityFont
        cityLabel.text = "seoul"
        tmpView.addSubview(tempLabel)
        tempLabel.text = "18"
        tempLabel.font = tempFont
        tempImageView.image = UIImage(resource: .sunny)
}
    func setupConstraints() {
        dayLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        cityLabel.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
        nationLabel.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).inset(-13)
            $0.leading.equalTo(cityLabel.snp.trailing).inset(-2)
        }
        tmpView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(132)
            $0.bottom.equalToSuperview().inset(424)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview()
        }
        markImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(27)
            $0.trailing.equalToSuperview().inset(351)
            
        }
        tempImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().offset(161)
        }
        tempLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(166)
            $0.bottom.equalTo(tableView.snp.top).inset(-26)
            $0.leading.trailing.equalToSuperview()
           
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(tmpView.snp.bottom).inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(80)
        }
    }
    
}

extension FashionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
