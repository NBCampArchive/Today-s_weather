//
//  CustomSegmentedControl.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/15/24.
//

import UIKit
import SnapKit

class CustomSegmentedControl: UISegmentedControl {
    
    private(set) lazy var radius:CGFloat = bounds.height / 2
    
    private var segmentInset: CGFloat = 0.1{
        didSet{
            if segmentInset == 0{
                segmentInset = 0.1
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        selectedSegmentIndex = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // SegmentedControl의 cornerRadius 설정
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true
        
        self.backgroundColor = UIColor(named: "segmentBackground")
        
        // 각 세그먼트의 배경색 설정
//        for segment in self.subviews {
//            if subviews[selectedSegmentIndex] != segment{
//                segment.layer.backgroundColor = UIColor(named: "segmentBackground")?.cgColor
//            }
//        }
        for i in 0...5{
            if i != self.selectedSegmentIndex{
                self.subviews[i].layer.backgroundColor = UIColor(named: "segmentBackground")?.cgColor
            }
        }
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 5
//        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        
        // 선택한 세그먼트의 인덱스 가져오기
        let selectedSegmentIndex = self.selectedSegmentIndex
        print("selectedSegmentIndex: \(selectedSegmentIndex)")
        
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView
        {
            //MARK: - Configure selectedImageView Color
            selectedImageView.backgroundColor = .white
            selectedImageView.image = nil
            
            //MARK: - Configure selectedImageView Inset with SegmentControl
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            
            //MARK: - Configure selectedImageView cornerRadius
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = self.radius
            
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")
        }
        
        
    }
}
