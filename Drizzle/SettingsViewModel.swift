//
//  SettingsViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 10/6/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import ReactiveKit

protocol SettingsViewModelType {
  var useMetric: Observable<Bool> { get }
}

class SettingsViewModel: SettingsViewModelType {
  let useMetric: Observable<Bool>
  
  private let userDefaults: UserDefaults!
  private let disposeBag = DisposeBag()
  
  init(userDefaults: UserDefaults = UserDefaults.standard)
  {
    self.userDefaults = userDefaults
    
    useMetric = Observable(self.userDefaults.value(forKey: "useMetric") as? Bool ?? false)
    useMetric.observe { [weak self] event in
      self?.userDefaults.set(event.element, forKey: "useMetric")
    }
    .dispose(in: disposeBag)
  }
  
  deinit {
    disposeBag.dispose()
  }
}
