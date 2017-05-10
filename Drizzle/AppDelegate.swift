//
//  AppDelegate.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let homeViewController = HomeViewController()
    
    let navigationController = UINavigationController(rootViewController: homeViewController)
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController.navigationBar.shadowImage = UIImage()
    navigationController.navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    return true
  }
  
//  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//    let notificationHour: Int = UserDefaults.standard.value(forKey: "notification_hour") as! Int
//    let notificationMinute: Int = UserDefaults.standard.value(forKey: "notification_minute") as! Int
//    let comps = Calendar.current.dateComponents([.hour, .minute], from: Date())
//    
//    if notificationHour == comps.hour! &&
//       comps.minute! - notificationMinute <= 5 &&
//       comps.minute! - notificationMinute >= 0 {
//      
//      let message = WeatherViewModel().getWeatherForecast()
//      
//      UNUserNotificationCenter.current().getNotificationSettings { notificationSettings in
//        switch notificationSettings.authorizationStatus {
//        case .authorized:
//          NSLog("LOGGING: Scheduled Notification")
//          self.scheduleLocalNotification(message: message)
//        case .notDetermined:
//          fallthrough
//        case.denied:
//          NSLog("Error: Application not authorized to display notifications")
//        }
//      }
//      
//      completionHandler(.newData)
//    }
//    else {
//      completionHandler(.noData)
//    }
//    
//  }
  
//  private func scheduleLocalNotification(message: String)
//  {
//    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//      let request = requests.filter { $0.identifier == "drizzle_daily_forecast" }.first
//      
//      let newContent = UNMutableNotificationContent()
//      newContent.title = request?.content.title ?? "Daily Weather Forecast"
//      newContent.body = message
//      
//      let newRequest = UNNotificationRequest(identifier: "drizzle_daily_forecast",
//                                             content: newContent,
//                                             trigger: request?.trigger)
//      UNUserNotificationCenter.current().add(newRequest) { (error) in
//        if let error = error {
//          NSLog("Unable to add notification request (\(error), \(error.localizedDescription))")
//        }
//      }
//    }
//  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

