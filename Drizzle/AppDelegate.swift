//
//  AppDelegate.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON // Temporary

// Set up global logging
import SwiftyBeaver
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  lazy var coreDataStack = CoreDataStack(modelName: "DrizzleModel")

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    // Set up and add log destinations:
    let console = ConsoleDestination()
    log.addDestination(console)
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    // Temprorary Fix for Crashing on Startup
    let oldData: [String: Any]? = UserDefaults.standard.value(forKey: "home_location") as? [String : Any]
    if let data = oldData {
      let json = JSON(data)
      UserDefaults.standard.set(json.stringValue, forKey: "home_location")
    }
    
    let homeViewController = HomeViewController(managedContext: coreDataStack.managedContext)
    
    let navigationController = UINavigationController(rootViewController: homeViewController)
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController.navigationBar.shadowImage = UIImage()
    navigationController.navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    return true
  }

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
    coreDataStack.saveContext()
  }
}

#if DEBUG
// Mark: - Determine if Running Tests
func isRunningUnitTests() -> Bool
{
  return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}
#endif

