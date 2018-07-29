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
    var items = [Item]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    // encode each property of the class List
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.CodingKeys.List.name)
        // encodes items as a array, will encode each element as objects of Item class.
        aCoder.encode(items, forKey: Constants.CodingKeys.List.items)
    }
    
    //decodes each property of list
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: Constants.CodingKeys.List.name) as! String
        // decodes items as an array, will decode each element as object of item class.
        items = aDecoder.decodeObject(forKey: Constants.CodingKeys.List.items) as! [Item]
        super.init()
    }
}
