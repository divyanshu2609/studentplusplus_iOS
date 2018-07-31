//
//  Date + Checklist.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 31/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import Foundation

extension Date{
    
    //converts the date into string format
    func formatInString() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
