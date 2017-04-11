//
//  HomeViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import UIKit

protocol HomeViewModelType {
  var homeLocation: Location? { get }
  
}

class HomeViewModel: HomeViewModelType {
  var homeLocation: Location?
  
  fileprivate let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = UserDefaults.standard)
  {
    self.userDefaults = userDefaults
    
    homeLocation = fetchHomeLocation()
  }
}

// MARK: - Interface
extension HomeViewModel {
  
}

// MARK: - Helpers
fileprivate extension HomeViewModel {
  static let HomeLocationKey = "home_location"
  
  func fetchHomeLocation() -> Location?
  {
    guard let decodedData = userDefaults.object(forKey: HomeViewModel.HomeLocationKey) as? Data
      else { return nil }
    
    return NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? Location ?? nil
  }
}
