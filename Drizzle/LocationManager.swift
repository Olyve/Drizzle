//
//  LocationManager.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/13/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import SwiftyJSON

protocol LocationManagerType {
  var homeLocation: Observable<Location?> { get }
  
  func setHomeLocation(location: Location)
}

class LocationManager: LocationManagerType {
  let homeLocation = Observable<Location?>(nil)
  
  fileprivate let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = UserDefaults.standard)
  {
    self.userDefaults = userDefaults
    
    userDefaults.reactive
      .keyPath(LocationManager.HomeLocationKey, ofType: Optional<String>.self, context: .immediateOnMain)
      .map { [weak self] in self?.initLocation(from: $0) }
      .bind(to: homeLocation)
  }
}

// MARK: - Interface
extension LocationManager {
  func setHomeLocation(location: Location)
  {
    userDefaults.set(location.toJSON().rawString(), forKey: LocationManager.HomeLocationKey)
  }
}

// MARK: - Helpers
extension LocationManager {
  static let HomeLocationKey = "home_location"
  
  func initLocation(from string: String?) -> Location?
  {
    guard let dataString = string
      else { log.warning("Location data did not exist, returning nil"); return nil }
    
    let json = JSON.parse(dataString)
    
    return Location(from: json)
  }
}
