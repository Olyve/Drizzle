//
//  SettingsViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/9/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import CoreData
import ReactiveKit
import UIKit

class SettingsViewController: UIViewController {
  @IBOutlet weak var unitLabel: UILabel!
  @IBOutlet weak var unitSwitch: UISwitch!
  
  private let managedContext: NSManagedObjectContext!
  private let locationManager: LocationManager!
  private let disposeBag = DisposeBag()
  
  init(managedContext: NSManagedObjectContext)
  {
    
    self.managedContext = managedContext
    self.locationManager = LocationManager(managedContext: managedContext)
    
    super.init(nibName: "SettingsViewController", bundle: nil)
    
    // TODO: Remove this force unwrap
    locationManager
      .homeLocation
      .flatMap { location in
        if let location = location {
          return location.useMetric
        }
        
        return false
      }
      .bind(to: unitSwitch.reactive.isOn)

    unitSwitch.reactive.isOn.observe { [weak self] event in
      self?.locationManager.homeLocation.value?.useMetric = event.element!
      
      do { try self?.managedContext.save() }
      catch let error { log.error(error.localizedDescription) }
    }
    .dispose(in: disposeBag)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    disposeBag.dispose()
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
