//
//  LocationManager.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/13/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import ReactiveKit
import SwiftyJSON

protocol LocationManagerType {
  var homeLocation: Observable<Location?> { get }
  var useMetricUnits: Observable<Bool> { get }
  
  func setHomeLocation(location: Location)
  func setUseMetrics(use: Bool)
  func getWeatherForHome()
}

class LocationManager: LocationManagerType {
  let homeLocation = Observable<Location?>(nil)
  let useMetricUnits = Observable<Bool>(false)
  
  fileprivate let userDefaults: UserDefaults
  fileprivate let fetchWeather: FetchWeatherType
  
  fileprivate let disposeBag = DisposeBag()
  
  init(userDefaults: UserDefaults = UserDefaults.standard,
       fetchWeather: FetchWeatherType = FetchWeather())
  {
    self.userDefaults = userDefaults
    self.fetchWeather = fetchWeather
    
    userDefaults.reactive
      .keyPath(LocationManager.HomeLocationKey, ofType: Optional<String>.self, context: .immediateOnMain)
      .map { [weak self] in self?.initLocation(from: $0) }
      .bind(to: homeLocation)
    
    userDefaults.reactive
      .keyPath(LocationManager.UseMetricKey, ofExpectedType: Bool.self, context: .immediateOnMain)
      .observeNext { [weak self] useMetrics in
        self?.useMetricUnits.value = useMetrics
      }
      .dispose(in: disposeBag)
  }
  
  deinit {
    disposeBag.dispose()
  }
}

// MARK: - Interface
extension LocationManager {
  func setHomeLocation(location: Location)
  {
    userDefaults.set(location.toJSON().rawString(), forKey: LocationManager.HomeLocationKey)
  }
  
  func setUseMetrics(use: Bool)
  {
    userDefaults.set(use, forKey: LocationManager.UseMetricKey)
  }
  
  func getWeatherForHome()
  {
    if let location = homeLocation.value {
      fetchWeather.fetchWeather(for: location, usingMetrics: useMetricUnits.value)
        .then { json -> Void in
          location.currentWeather = self.parseCurrentWeather(from: json)
          location.dailyWeather = self.parseDailyWeather(from: json)
          
          self.setHomeLocation(location: location)
        }
        .catch(execute: { (error) in
          log.error(error.localizedDescription)
        })
    }
  }
}

// MARK: - Helpers
extension LocationManager {
  static let HomeLocationKey = "home_location"
  static let UseMetricKey = "use_metric"
  
  func initLocation(from string: String?) -> Location?
  {
    guard let dataString = string
      else { log.warning("Location data did not exist, returning nil"); return nil }
    
    let json = JSON.parse(dataString)
    
    return Location(from: json)
  }
  
  func parseCurrentWeather(from json: JSON) -> CurrentWeather?
  {
    let currently = json["currently"]
    
    return CurrentWeather(summary: currently["summary"].stringValue,
                          icon: currently["icon"].stringValue,
                          temperature: currently["temperature"].intValue,
                          apparentTemperature: currently["apparentTemperature"].intValue)
  }
  
  // For now, this only pulls the current day aka. [0]
  func parseDailyWeather(from json: JSON) -> [DailyWeather]?
  {
    var forecast: [DailyWeather]? = []
    
    // This skips the daily summary and icon
    let dailyData: [JSON] = json["daily"]["data"].arrayValue
    
    for day in dailyData {
      let dailyWeather = DailyWeather(time: day["time"].intValue,
                                      summary: day["summary"].stringValue,
                                      icon: day["icon"].stringValue,
                                      temperatureMin: day["temperatureMin"].intValue,
                                      temperatureMax: day["temperatureMax"].intValue,
                                      precipProbability: day["precipProbability"].doubleValue,
                                      precipType: day["precipType"].stringValue,
                                      humidity: day["humidity"].doubleValue,
                                      windSpeed: day["windSpeed"].doubleValue)
      forecast?.append(dailyWeather)
    }
    
    return forecast
  }
}
