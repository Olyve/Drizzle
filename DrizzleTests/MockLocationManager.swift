//
//  MockLocationManager.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/15/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import RxCocoa
import RxSwift

class MockLocationManager: LocationManagerType {
  var homeLocation = Variable<Location?>(nil)
  
  var setHomeLocationCalled = false
  func setHomeLocation(location: Location) {
    setHomeLocationCalled = true
  }
}
