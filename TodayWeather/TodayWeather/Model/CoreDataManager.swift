//
//  CoreDataManager.swift
//  TodayWeather
//
//  Created by 송정훈 on 5/20/24.


import UIKit
import CoreData

struct locationData {
    let latitude : Double
    let longitude : Double
    let locName : String
}

class CoreDataManager {
    var persistent : NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    //코어데이터 저장
    func saveData(Data : locationData) {
        guard let context = self.persistent?.viewContext else {return}
        let newloc = Saveweather(context: context)
        newloc.locname = Data.locName
        newloc.longitude = Data.longitude
        newloc.latitude = Data.latitude
        try? context.save()
    }
    //코어데이터 읽기
    func readData() -> [locationData] {
        var read = [locationData]()
        guard let context = self.persistent?.viewContext else { return read}
        let request = Saveweather.fetchRequest()
        let loadData = try? context.fetch(request)
        for i in loadData! {
            read.append(locationData(latitude: i.latitude, longitude: i.longitude, locName: i.locname ?? ""))
        }
        return read
    }
     //코어데이터 삭제
    func deleteData(num : Int) {
        
        guard let context = self.persistent?.viewContext else
        { return }
        let request = Saveweather.fetchRequest()
        guard let loadData = try? context.fetch(request) else {return}
        
        let filtered = loadData[num]
        context.delete(filtered)
        try? context.save()
    }
}
