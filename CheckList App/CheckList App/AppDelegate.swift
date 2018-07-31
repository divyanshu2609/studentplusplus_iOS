//
//  AppDelegate.swift
//  CheckList App
//
//  Created by Divyanshu Goel on 21/07/18.
//  Copyright © 2018 Divyanshu Goel. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataModel = DataModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = window?.rootViewController as! UINavigationController
        let viewController = navigationController.viewControllers[0] as! AllListViewController
        viewController.dataModel = dataModel
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }
    
    func saveData(){
        dataModel.saveCheckLists()
    }

//    func registerUserNotification(){
//        let center = UNUserNotificationCenter.current()
//        let options: UNAuthorizationOptions = [.alert, .sound]
//        center.requestAuthorization(options: options, completionHandler:{
//            (granted, error) in
//            if !granted{
//                print("Something went wrong!")
//            }
//        })
//
//        center.getNotificationSettings(completionHandler: {
//            (settings) in
//            if settings.authorizationStatus != .authorized{
//                print("Notification not authorized")
//            } else {
//                print("Notification authorized")
//                let content = UNMutableNotificationContent()
//                content.title = "Testing Notification"
//                content.body = "test is done! All is well"
//                content.sound = UNNotificationSound.default()
//
//                let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date(timeIntervalSinceNow: 30))
//
//                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//
//                let identifier = "UYLCalenderNotification"
//                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//                center.add(request) { (error) in
//                    if let error = error{
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        })
//    }

}


