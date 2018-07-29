//
//  DataModel.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 29/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import Foundation

class DataModel{
    var lists = [List]()
    
    init() {
        loadCheckLists()
    }

    func documentsDirectory()->String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath()->String{
        return documentsDirectory().stringByAppendingPathComponent(path: Constants.Paths.saveWithFileName)
    }
    
    func saveCheckLists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: Constants.CodingKeys.mainModelKey)
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    func loadCheckLists(){
        let path = dataFilePath()
        print(path)
        if FileManager.default.fileExists(atPath: path){
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
                lists = unarchiver.decodeObject(forKey: Constants.CodingKeys.mainModelKey) as! [List]
                unarchiver.finishDecoding()
            }
        }
    }
}
