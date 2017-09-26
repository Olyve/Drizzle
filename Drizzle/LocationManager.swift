//
//  LocationManager.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/13/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import CoreData
import Moya
import ReactiveKit
import SwiftyJSON

protocol LocationManagerType {
  var homeLocation: Observable<LocationMO?> { get }
  
  func setHomeLocation(location: Location)
  func getWeatherForHome()
}

class LocationManager: LocationManagerType {
  let homeLocation = Observable<LocationMO?>(nil)
  
  private let managedContext: NSManagedObjectContext!
  private let notificationCenter: NotificationCenter!
  private let apiProvider = MoyaProvider<APIService>()
  private let disposeBag = DisposeBag()
  
  init(managedContext: NSManagedObjectContext, notificationCenter: NotificationCenter = NotificationCenter.default)
  {
    self.managedContext = managedContext
    self.notificationCenter = notificationCenter
    
    homeLocation.value = getHomeLocation()
    
    // Observe for future changes
    notificationCenter.reactive.notification(name: .NSManagedObjectContextDidSave)
      .observe { [weak self] notification in
        self?.homeLocation.value = self?.getHomeLocation()
      }
      .dispose(in: disposeBag)
  }
  
  deinit {
    disposeBag.dispose()
  }
}

// MARK: - Interface
extension LocationManager {
  func getHomeLocation() -> LocationMO?
  {
    do {
      let locations = try managedContext.fetch(LocationMO.fetchRequest()) as [LocationMO]
      return locations.filter({ $0.isHome }).first
    }
    catch let error {
      log.error(error.localizedDescription)
      return nil
    }
  }
  
  func setHomeLocation(location: Location)
  {
    // TODO: For now, just delete everything. Fix this later
    do {
      let deleteLocations = NSBatchDeleteRequest(fetchRequest: LocationMO.fetchRequest())
      let deleteCurrentWeather = NSBatchDeleteRequest(fetchRequest: CurrentWeatherMO.fetchRequest())
      let deleteDailyWeather = NSBatchDeleteRequest(fetchRequest: DailyWeatherMO.fetchRequest())
      
      try managedContext.execute(deleteLocations)
      try managedContext.execute(deleteCurrentWeather)
      try managedContext.execute(deleteDailyWeather)
    }
    catch let error {
      log.error(error.localizedDescription)
    }
    
    let newHome = LocationMO(context: managedContext)
    
    newHome.latitude = location.latitude
    newHome.longitude = location.longitude
    newHome.address = location.formattedAddress
    newHome.lastFetchTime = location.lastFetchTime
    newHome.isHome = true
    
    saveChanges()
  }
  
  // TODO: This function is rather large, refactor it
  func getWeatherForHome()
  {
    if let location = homeLocation.value {
      apiProvider.request(.fetchWeather(location: location)) { result in
        switch result {
        case .success(let moyaResponse):
          do {
            try moyaResponse.filterSuccessfulStatusCodes()
            if let data = JSON(rawValue: try moyaResponse.mapJSON()) {
              self.parseCurrentWeather(from: data)
              self.parseDailyWeather(from: data)
              self.saveChanges()
            }
            else {
              log.error("Response from API failed: \(moyaResponse)")
            }
          }
          catch let error {
            log.error(error.localizedDescription)
            log.info(moyaResponse.response as Any)
          }
          
        case .failure(let error):
          log.error(error.localizedDescription)
        }
      }
    }
  }
}

// MARK: - Helpers
extension LocationManager {
  func saveChanges() {
    do {
      try managedContext.save()
    }
    catch let error {
      log.error(error.localizedDescription)
    }
  }
  
  func parseCurrentWeather(from json: JSON)
  {
    guard let home = homeLocation.value else { return }
    
    let currently = json["currently"]
    let currentWeather = CurrentWeatherMO(context: managedContext)
    
    currentWeather.summary = currently["summary"].stringValue
    currentWeather.icon = currently["icon"].stringValue
    currentWeather.temperature = currently["temperature"].int16Value
    currentWeather.apparentTemperature = currently["apparentTemperature"].int16Value
    
    home.currentWeather = currentWeather
  }
  
  func parseDailyWeather(from json: JSON)
  {
    guard let home = homeLocation.value else { return }
    
    // This skips the daily summary and icon
    let dailyData: [JSON] = json["daily"]["data"].arrayValue
    
    for day in dailyData {
      let dailyWeather = DailyWeatherMO(context: managedContext)
      
      dailyWeather.time = day["time"].int32Value
      dailyWeather.summary = day["summary"].stringValue
      dailyWeather.icon = day["icon"].stringValue
      dailyWeather.temperatureMin = day["temperatureMin"].int16Value
      dailyWeather.temperatureMax = day["temperatureMax"].int16Value
      dailyWeather.precipProbability = day["precipProbability"].doubleValue
      dailyWeather.precipType = day["precipType"].stringValue
      dailyWeather.humidity = day["humidity"].doubleValue
      dailyWeather.windSpeed = day["windSpeed"].doubleValue
      
      let mutableSet = home.dailyWeather?.mutableCopy() as! NSMutableOrderedSet
      mutableSet.add(dailyWeather)
      home.dailyWeather = mutableSet.copy() as? NSOrderedSet
    }
  }
}
