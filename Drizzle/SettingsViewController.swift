//
//  SettingsViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/9/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class SettingsViewController: UIViewController {
  @IBOutlet weak var unitLabel: UILabel!
  @IBOutlet weak var unitSwitch: UISwitch!
  
  private let viewModel: SettingsViewModelType
  private let disposeBag = DisposeBag()
  
  init(viewModel: SettingsViewModelType = SettingsViewModel())
  {
    self.viewModel = viewModel
    
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
      NSAttributedStringKey.foregroundColor: UIColor.drizzleWhite,
      NSAttributedStringKey.font: UIFont(name: "Quicksand-Regular", size: 20)!
    ]
    
    navigationItem.title = "Settings"
    
    // TODO: This feels wrong settings the reactive bind every time the view will appear,
    // It may even be causing a memory leak. Added disposing of the bind on disappear to maybe fix
    unitSwitch.isOn = UserDefaults.standard.value(forKey: "useMetric") as? Bool ?? false
    unitSwitch.reactive.isOn.bind(to: viewModel.useMetric).dispose(in: disposeBag)
  }
  
  override func viewWillDisappear(_ animated: Bool)
  {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.barStyle = .default
    disposeBag.dispose()
  }
}
