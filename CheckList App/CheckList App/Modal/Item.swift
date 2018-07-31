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
        //unique id given at time of initialization
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
    
    // toggles the property isChecked on rowclick
    func toggleChecked(){
        isChecked = !isChecked!
    }
    
    // schedule a notification on List item
    func scheduleNotification(forList list: List){
        removeNotificationsForThisItem(itemID: self.itemID!)
        if shouldRemind! && dueDate.compare(Date()) != ComparisonResult.orderedAscending{
            let content = UNMutableNotificationContent()
            content.body = list.name
            content.title = self.name!
            content.subtitle = (self.dueDate as Date).formatInString()
            content.sound = UNNotificationSound.default()
            content.userInfo = ["ItemID" : self.itemID]
           
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: dueDate as Date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let identifier = UserNotificationHandler.makeIdentifierString(baseIdentifier: Constants.NotificationIdentifiers.calenderNotificationIdentifier, Id: String(itemID!))
            UserNotificationHandler.scheduleNotification(content: content, trigger: trigger, identifier: identifier)
        }
    }
    
    // removes the notification for an item from Notification Center for a particluar item ID
    func removeNotificationsForThisItem(itemID: Int){
        let closure = {
            (notifications: [UNNotificationRequest])->UNNotificationRequest? in
            for notification in notifications{
                if let number = notification.content.userInfo["ItemID"] as? NSNumber{
                    if number.intValue == itemID{
                        return notification
                    }
                }
            }
            return nil
        }
        UserNotificationHandler.getAllNotifications(closure: closure)
    }
    
    // Called when the item gets destroyed - both when individual items gets deleted as well as the whole list gets deleted.
    deinit {
        removeNotificationsForThisItem(itemID: self.itemID!)
    }
}
