//
//  HomeViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import CoreData


protocol HomeViewModelType {
  var homeLocation: Observable<LocationMO?> { get }
  
  func updateWeatherInfo()
}

class HomeViewModel: HomeViewModelType {
  let homeLocation = Observable<LocationMO?>(nil)
  
  private let managedContext: NSManagedObjectContext!
  private let locationManager: LocationManagerType
  
  init(managedContext: NSManagedObjectContext)
  {
    self.managedContext = managedContext
    self.locationManager = LocationManager(managedContext: self.managedContext)
    
    locationManager.homeLocation.bind(to: homeLocation)
  }
  
  func updateWeatherInfo() {
    locationManager.getWeatherForHome()
  }
}

