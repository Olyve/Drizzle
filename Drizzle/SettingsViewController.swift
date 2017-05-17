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
    navigationController?.navigationBar.tintColor = UIColor.drizzleWhite
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
