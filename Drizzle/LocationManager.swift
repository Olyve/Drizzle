//
//  LocationManager.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/13/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyJSON

protocol LocationManagerType {
  var homeLocation: Variable<Location?> { get }
  
  func setHomeLocation(location: Location)
}

class LocationManager: LocationManagerType {
  let homeLocation = Variable<Location?>(nil)
  
  private let disposeBag = DisposeBag()
  
  fileprivate let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = UserDefaults.standard)
  {
    self.userDefaults = userDefaults
    
    userDefaults.rx.observe(String.self, LocationManager.HomeLocationKey).asObservable()
      .map { self.initLocation(from: $0) }
      .bindTo(self.homeLocation)
      .addDisposableTo(disposeBag)
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
      else { NSLog("Location data did not exist, returning nil"); return nil }
    
    let json = JSON.parse(dataString)
    
    return Location(from: json)
  }
}
