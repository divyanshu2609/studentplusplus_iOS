//
//  Constants.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 29/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import Foundation
struct Constants{
    struct Paths{
        static let saveWithFileName = "CheckLists.plist"
    }
    
    struct UserDefaultKeys{
        static let checkListIndex = "CheckListIndex"
    }
    
    struct StoryboardIds{
        static let addListNavigationController = "AddListNavigationController"
    }
    
    struct CellIdentifiers{
        static let allListTableViewCell = "AllListTableViewCell"
        static let checklistitem = "ChecklistItem"
    }
    
    struct SegueIdentifiers {
        static let showChecklist = "ShowList"
        static let addChecklist = "AddList"
        static let addItem = "AddItem"
        static let editItem = "EditItem"
    }
    
    struct SpecialSymbols{
        static let checkMark = "✔︎"
    }
    
    // Don't change the values of coding keys , else the app will crash. If you need to mofify the values, delete the CheckLists.plist file in the device sandbox.
    struct CodingKeys{
        static let mainModelKey = "CheckLists"
        struct List {
            static let name = "name"
            static let items = "items"
        }
        struct Item {
            static let name = "name"
            static let isChecked = "isChecked"
        }
    }
}
