//
//  MockLocationManager.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/15/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
@testable import Drizzle

class MockLocationManager: LocationManagerType {
  var useMetricUnits: Property<Bool>
  
  func setUseMetrics(use: Bool) {
    
  }
  
  func getWeatherForHome() {
    
  }
  
  var homeLocation = Observable<Location?>(nil)
  
  var setHomeLocationCalled = false
  func setHomeLocation(location: Location) {
    setHomeLocationCalled = true
  }
}
