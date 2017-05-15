//
//  SettingsViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/9/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
  @IBOutlet weak var alarmPicker: UIDatePicker!
  @IBAction func confirmTimeTapped(_ sender: UIButton)
  {
    // Notification are not working as intended at the moment.
    // FIXME: Notifications
    //setNotificationTimeAndHandleAuthorization()
  }
  
  fileprivate let weatherManager: WeatherManagerType
  
  init(weatherManager: WeatherManagerType = WeatherManager())
  {
    self.weatherManager = weatherManager
    
    super.init(nibName: "SettingsViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - View Life Cycle
extension SettingsViewController {
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.drizzleWhite,
      NSFontAttributeName: UIFont(name: "Quicksand-Regular", size: 20)!
    ]
    
    navigationItem.title = "Settings"
    
    alarmPicker.setValue(UIColor.drizzleWhite, forKey: "textColor")
    alarmPicker.datePickerMode = .dateAndTime
    alarmPicker.datePickerMode = .time
    alarmPicker.minuteInterval = 5
  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.barStyle = .default
  }
}

// MARK: - Notification Settings
fileprivate extension SettingsViewController {
  func setNotificationTimeAndHandleAuthorization()
  {
    UNUserNotificationCenter.current().getNotificationSettings { notificationSettings in
      switch notificationSettings.authorizationStatus {
      case .notDetermined:
        self.requestAuthorization(completionHandler: { (success) in
          guard success else { return }
          
          self.scheduleLocalNotification()
        })
      case .authorized:
        self.scheduleLocalNotification()
      case.denied:
        NSLog("Error: Application not authorized to display notifications")
      }
    }
  }
  
  func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
      if let error = error {
        NSLog("Request Authorization Failed (\(error), \(error.localizedDescription))")
      }
      
      completionHandler(success)
    }
  }
  
  func scheduleLocalNotification()
  {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["drizzle_local_notification"])
    
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "Daily Weather Forecast"
    notificationContent.body = UserDefaults.standard.value(forKey: "notification_content") as? String ?? "Error: Unable to grab forecast data, sorry!"
    
    let dateComponenets = alarmPicker.calendar.dateComponents([.hour, .minute], from: alarmPicker.date)
    
    UserDefaults.standard.set(dateComponenets.hour, forKey: "notification_hour")
    UserDefaults.standard.set(dateComponenets.minute, forKey: "notification_hour")
    
    let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponenets, repeats: true)
    
    let notificationRequest = UNNotificationRequest(identifier: "drizzle_local_notification",
                                                    content: notificationContent,
                                                    trigger: notificationTrigger)
    
    UNUserNotificationCenter.current().add(notificationRequest) { (error) in
      if let error = error {
        NSLog("Unable to add notification request (\(error), \(error.localizedDescription))")
      }
    }
  }
}


