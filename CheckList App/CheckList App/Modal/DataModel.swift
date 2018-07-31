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
    var indexOfSelectedCheckList: Int{
        get{
            return UserDefaults.standard.integer(forKey: Constants.UserDefaultKeys.checkListIndex)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultKeys.checkListIndex)
        }
    }
    
    init() {
        loadCheckLists()
        registerUserDefaults()
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
                sortCheckLists()
            }
        }
    }
    
    func registerUserDefaults(){
        let keyValue = [Constants.UserDefaultKeys.checkListIndex: -1, Constants.UserDefaultKeys.checkListItemID: 0]
        UserDefaults.standard.register(defaults: keyValue)
    }
    
    func sortCheckLists(){
        lists.sort(by: {list1,list2 in return list1.name.localizedStandardCompare(list2.name) == ComparisonResult.orderedAscending})
    }
    
    class func nextCheckListItemID()-> Int{
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: Constants.UserDefaultKeys.checkListItemID)
        userDefaults.set(itemID + 1, forKey: Constants.UserDefaultKeys.checkListItemID)
        userDefaults.synchronize()
        return itemID
    }
}
