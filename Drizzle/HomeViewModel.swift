//
//  HomeViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import CoreData
import ReactiveKit

protocol HomeViewModelType {
  var homeLocation: Observable<LocationMO?> { get }
  var useMetric: Observable<Bool>{ get }
  
  func updateWeatherInfo()
}

class HomeViewModel: HomeViewModelType {
  let homeLocation = Observable<LocationMO?>(nil)
  let useMetric = Observable<Bool>(false)
  
  private let managedContext: NSManagedObjectContext!
  private let locationManager: LocationManagerType
  private let userDefaults: UserDefaults!
  private let disposeBag = DisposeBag()
  
  init(managedContext: NSManagedObjectContext, userDefaults: UserDefaults = UserDefaults.standard)
  {
    self.managedContext = managedContext
    self.locationManager = LocationManager(managedContext: self.managedContext)
    self.userDefaults = userDefaults
    
    locationManager.homeLocation.bind(to: homeLocation)
    
    userDefaults.reactive
      .keyPath("useMetric", ofExpectedType: Bool.self, context: .immediateOnMain)
      .observeNext { [weak self] value in
        self?.useMetric.value = value
      }
      .dispose(in: disposeBag)
  }
  
  deinit {
    disposeBag.dispose()
  }
  
  func updateWeatherInfo() {
    locationManager.getWeatherForHome()
  }
}

