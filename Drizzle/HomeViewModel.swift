//
//  HomeViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import PromiseKit
import SwiftyJSON
import UIKit

protocol HomeViewModelType {
  var homeLocation: Observable<Location?> { get }
  
  func updateWeatherInfo()
}

class HomeViewModel: HomeViewModelType {
  let homeLocation = Observable<Location?>(nil)
  
  fileprivate let locationManager: LocationManagerType
  
  init(locationManager: LocationManagerType = LocationManager())
  {
    self.locationManager = locationManager
    
    locationManager.homeLocation.bind(to: homeLocation)
  }
  
  func updateWeatherInfo() {
    locationManager.getWeatherForHome()
  }
}

