//
//  MockLocationManager.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/17/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import RxCocoa
import RxSwift

class MockLocationManager: LocationManagerType {
  let homeLocation = Variable<Location?>(nil)
}
