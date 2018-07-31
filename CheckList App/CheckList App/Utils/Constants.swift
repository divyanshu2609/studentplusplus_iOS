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
        static let checkListItemID = "CheckListItemID"
    }
    
    struct StoryboardIds{
        static let addListNavigationController = "AddListNavigationController"
    }
    
    struct NotificationIdentifiers {
        static let calenderNotificationIdentifier = "CalenderNotification"
        static let timeIntervalIdentifier = "UYLLocalNotification"
    }
    
    struct ViewTags{
        static let checkListItemLabelTag = 100
        static let checkMarkItemLabelTag = 101
        static let datePickerTag = 102
        static let checkListItemSubtitleLabelTag = 103
    }
    
    struct CellIdentifiers{
        static let allListTableViewCell = "AllListTableViewCell"
        static let checklistitem = "ChecklistItem"
        static let iconPickerCell = "IconPickerCell"
        static let datePickerCell = "DatePickerCell"
    }
    
    struct SegueIdentifiers {
        static let showChecklist = "ShowList"
        static let addChecklist = "AddList"
        static let addItem = "AddItem"
        static let editItem = "EditItem"
        static let pickIcon = "PickIcon"
    }
    
    struct SpecialSymbols{
        static let checkMark = "✔︎"
    }
    
    // Don't change the values of coding keys , else the app will crash. If you need to mofify the values, delete the CheckLists.plist file in the device sandbox.
    struct CodingKeys{
        static let mainModelKey = "CheckLists"
        struct List {
            static let name = "Name"
            static let items = "Items"
            static let iconName = "IconName"
        }
        struct Item {
            static let name = "Name"
            static let isChecked = "IsChecked"
            static let dueDate = "DueDate"
            static let shouldRemind = "ShouldRemind"
            static let itemId = "ItemId"
        }
    }
}
