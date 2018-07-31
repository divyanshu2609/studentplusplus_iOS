//
//  List.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 25/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit

class List: NSObject, NSCoding {
    
    var name = ""
    var iconName: String
    var items = [Item]()
    
    //convinience is used as we have called the init on the same class inside an init.
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    // encode each property of the class List
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.CodingKeys.List.name)
        // encodes items as a array, will encode each element as objects of Item class.
        aCoder.encode(iconName, forKey: Constants.CodingKeys.List.iconName)
        aCoder.encode(items, forKey: Constants.CodingKeys.List.items)
    }
    
    //decodes each property of list
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: Constants.CodingKeys.List.name) as! String
        // decodes items as an array, will decode each element as object of item class.
        iconName = aDecoder.decodeObject(forKey: Constants.CodingKeys.List.iconName) as! String
        items = aDecoder.decodeObject(forKey: Constants.CodingKeys.List.items) as! [Item]
        super.init()
    }
    
    // counts the number of unchecked items
    func countUncheckedItems()->Int{
        var count = 0
        for item in items{
            if !item.isChecked!{
                count += 1
            }
        }
        return count
    }
    
    //sorting the checklist items
    func sortCheckListItems(){
        items.sort(by: {item1,item2 in return (item1.dueDate as Date).compare(item2.dueDate as Date) == ComparisonResult.orderedAscending})
    }
}
