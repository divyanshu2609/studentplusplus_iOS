//
//  Item.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 21/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import Foundation
import UserNotifications


class Item: NSObject, NSCoding{
    var name: String?
    var isChecked: Bool?
    var shouldRemind: Bool?
    var dueDate = NSDate()
    var itemID: Int?
    
    override init(){
        itemID = DataModel.nextCheckListItemID()
        super.init()
    }
    
    // decodes each property of item class with their respective data types.
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: Constants.CodingKeys.Item.name) as? String
        isChecked = aDecoder.decodeObject(forKey: Constants.CodingKeys.Item.isChecked) as? Bool
        dueDate = (aDecoder.decodeObject(forKey: Constants.CodingKeys.Item.dueDate) as? NSDate)!
        itemID = aDecoder.decodeObject(forKey: Constants.CodingKeys.Item.itemId) as? Int
        shouldRemind = aDecoder.decodeObject(forKey: Constants.CodingKeys.Item.shouldRemind) as? Bool
        
        super.init()
    }
    
    // encode each property of item class.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Constants.CodingKeys.Item.name)
        aCoder.encode(isChecked, forKey: Constants.CodingKeys.Item.isChecked)
        aCoder.encode(dueDate, forKey: Constants.CodingKeys.Item.dueDate)
        aCoder.encode(shouldRemind, forKey: Constants.CodingKeys.Item.shouldRemind)
        aCoder.encode(itemID, forKey: Constants.CodingKeys.Item.itemId)
    }
    
    func toggleChecked(){
        isChecked = !isChecked!
    }
    
    func scheduleNotification(){
        removeNotificationsForThisItem(itemID: self.itemID!)
        if shouldRemind! && dueDate.compare(Date()) != ComparisonResult.orderedAscending{
            let content = UNMutableNotificationContent()
            //content.title = "Testing Notification"
            content.body = self.name!
            content.sound = UNNotificationSound.default()
            content.userInfo = ["ItemID" : self.itemID]
           
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: dueDate as Date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let identifier = Constants.NotificationIdentifiers.calenderNotificationIdentifier
            UserNotificationHandler.scheduleNotification(content: content, trigger: trigger, identifier: identifier)
        }
    }
    
    func removeNotificationsForThisItem(itemID: Int){
        let closure = {
            (notifications: [UNNotificationRequest])->UNNotificationRequest? in
//            print(notifications)
//            print("item id : \(itemID)")
            for notification in notifications{
//                print(notification)
                if let number = notification.content.userInfo["ItemID"] as? NSNumber{
//                    print(number.intValue)
                    if number.intValue == itemID{
//                        print("found an existing notification \(notification)")
                        return notification
                    }
                }
            }
            return nil
        }
        UserNotificationHandler.getAllNotifications(closure: closure)
    }
    
    deinit {
//        print(self)
        removeNotificationsForThisItem(itemID: self.itemID!)
    }
}
