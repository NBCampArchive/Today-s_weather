//
//  DustAPIManager.swift
//  TodayWeather
//
//  Created by 박현렬 on 5/14/24.
//

import Foundation
import Alamofire

class DustAPIManager{
    
    static let shared = DustAPIManager()
    
    private init(){}
    
    func getDustData(latitude: Double, longitude: Double, completion: @escaping (Result<DustResponseModel, Error>) -> Void){
        let url = "https://api.waqi.info/feed/geo:\(latitude);\(longitude)/?token=\(Bundle.main.dustApiKey)"
        
        AF.request(url).validate().responseDecodable(of: DustResponseModel.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
}
