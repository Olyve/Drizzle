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
  
  func getWeatherForHome()
}

class HomeViewModel: HomeViewModelType {
  enum Errors: Error {
    case weatherFetched
  }
  
  let homeLocation = Observable<Location?>(nil)
  
  fileprivate let locationManager: LocationManagerType
  fileprivate let fetchWeather: FetchWeatherType
  
  init(locationManager: LocationManagerType = LocationManager(),
       fetchWeather: FetchWeatherType = FetchWeather())
  {
    self.locationManager = locationManager
    self.fetchWeather = fetchWeather
    
    locationManager.homeLocation.bind(to: self.homeLocation)
  }
}

// MARK: - Interface
extension HomeViewModel {
  func getWeatherForHome()
  {
    if let location = homeLocation.value {
      _ = fetchWeather.fetchWeather(for: location)
        .then { json -> Void in
          location.currentWeather = self.parseCurrentWeather(from: json)
          location.dailyWeather = self.parseDailyWeather(from: json)
        }
    }
  }
}

fileprivate extension HomeViewModel {
  func parseCurrentWeather(from json: JSON) -> CurrentWeather?
  {
    let currently = json["currently"]
    
    return CurrentWeather(summary: currently["summary"].stringValue,
                          icon: currently["icon"].stringValue,
                          temperature: currently["temperature"].doubleValue,
                          apparentTemperature: currently["apparentTemperature"].doubleValue)
  }
  
  // For now, this only pulls the current day aka. [0]
  func parseDailyWeather(from json: JSON) -> DailyWeather?
  {
    // This skips the daily summary and icon
    let daily = json["daily"]["data"][0]
    
    return DailyWeather(temperatureMin: daily["temperatureMin"].doubleValue,
                        temperatureMax: daily["temperatureMax"].doubleValue,
                        precipProbability: daily["precipProbability"].doubleValue,
                        precipType: daily["precipType"].stringValue,
                        humidity: daily["humidity"].doubleValue,
                        windSpeed: daily["windSpeed"].doubleValue)
  }
}
