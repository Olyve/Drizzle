//
//  SettingsViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/9/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
  @IBOutlet weak var unitLabel: UILabel!
  @IBOutlet weak var unitSwitch: UISwitch!
  
  init()
  {
    super.init(nibName: "SettingsViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - View Life Cycle
extension SettingsViewController {
  override func viewDidLoad()
  {
    
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.tintColor = UIColor.drizzleWhite
    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedStringKey.foregroundColor: UIColor.drizzleWhite,
      NSAttributedStringKey.font: UIFont(name: "Quicksand-Regular", size: 20)!
    ]
    
    navigationItem.title = "Settings"
  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.barStyle = .default
  }
}
