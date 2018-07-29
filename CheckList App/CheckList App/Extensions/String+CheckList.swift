//
//  String+CheckList.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 22/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import Foundation
extension String{
    
    // function strings(byAppendingPaths) exists for NSString only, so making an extension for String to be able to use this function with String too.
    func stringByAppendingPathComponent(path: String) -> String {
        let string = self as NSString
        let pathStrings = string.strings(byAppendingPaths: [path])
        return pathStrings[0]
    }
}
