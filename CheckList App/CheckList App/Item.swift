//
//  Item.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 21/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import Foundation


class Item: NSObject, NSCoding{
    var name: String?
    var isChecked: Bool?
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        isChecked = aDecoder.decodeObject(forKey: "isChecked") as? Bool
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(isChecked!, forKey: "isChecked")
    }
    
    
    func toggleChecked(){
        isChecked = !isChecked!
    }
}
