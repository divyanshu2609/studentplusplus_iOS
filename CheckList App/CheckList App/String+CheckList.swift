//
//  String+CheckList.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 22/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import Foundation
extension String{
    func stringByAppendingPathComponent(path: String) -> String {
        let string = self as NSString
        let pathStrings = string.strings(byAppendingPaths: [path])
        return pathStrings[0]
    }
}
