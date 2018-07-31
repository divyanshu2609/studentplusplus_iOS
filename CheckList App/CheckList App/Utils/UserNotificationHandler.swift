//
//  UserNotificationHandler.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 30/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import Foundation
import UserNotifications

class UserNotificationHandler{
    
    static let center = UNUserNotificationCenter.current()
    static let options: UNAuthorizationOptions = [.alert,.sound]
    
    class func registerAuthorization(){
        center.requestAuthorization(options: [options], completionHandler:{
            (granted, error) in
            if !granted{
               // print("Something went wrong!")
            }
        })
    }
    
    class func scheduleNotification(content: UNMutableNotificationContent, trigger: UNNotificationTrigger, identifier: String){
        center.getNotificationSettings(completionHandler: {
            (settings) in
            if settings.authorizationStatus != .authorized{
                //print("Notification not authorized")
            } else {
                //print("Notification authorized")
                let content = content
                let trigger = trigger
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                center.add(request) { (error) in
                    if let error = error{
//                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
    
    class func getAllNotifications(closure: @escaping ([UNNotificationRequest])->UNNotificationRequest?){
        center.getPendingNotificationRequests(completionHandler: { (notifications) in
            let notificationsRequests: [UNNotificationRequest]? = notifications
            if let request = notificationsRequests{
                if request.count > 0{
                    if let notification = closure(request){
                        UserNotificationHandler.removePendingNotification(notification: notification)
                    }
                }
            }
        })
        center.getDeliveredNotifications { (notifications) in
            let notificationRequests: [UNNotificationRequest]? = notifications.map({
                (notification) in
                return notification.request
            })
            if let requests = notificationRequests{
                if requests.count > 0{
                    if let notification = closure(requests){
                        UserNotificationHandler.removePendingNotification(notification: notification)
                    }
                }
            }
        }
    }
    
    class func removePendingNotification(notification: UNNotificationRequest){
        center.removeDeliveredNotifications(withIdentifiers: [notification.identifier])
        center.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
        //print("Removing existing notification \(notification.identifier)\n\n")
    }
    
    class func makeIdentifierString(baseIdentifier: String, Id: String) -> String{
        return "\(baseIdentifier)\(Id)"
    }
}
