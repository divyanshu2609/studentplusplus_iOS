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
    
    // decodes each property of item class with their respective data types.
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: Constants.CodingKeys.Item.name) as? String
        isChecked = aDecoder.decodeObject(forKey: Constants.CodingKeys.Item.isChecked) as? Bool
        super.init()
    }
    
    // encode each property of item class.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.CodingKeys.Item.name)
        aCoder.encode(isChecked, forKey: Constants.CodingKeys.Item.isChecked)
        
    }
    
    func toggleChecked(){
        isChecked = !isChecked!
    }
}
