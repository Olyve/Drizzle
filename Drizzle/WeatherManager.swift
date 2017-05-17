//
//  WeatherManager.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/9/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import PromiseKit
import RxSwift
import RxCocoa
import SwiftyJSON

protocol WeatherManagerType {
  var weatherFetched: Bool { get }
  var currentWeather: Variable<JSON?> { get }
  var dailyWeather: Variable<JSON?> { get }
  
  func getWeatherForecast() -> String
  func getWeatherForHome()
  func getWeatherIcon() -> String
}

class WeatherManager: WeatherManagerType {
  enum Errors: Error {
    case weatherFetched
  }
  
  var weatherFetched = false
  var currentWeather = Variable<JSON?>(nil)
  var dailyWeather = Variable<JSON?>(nil)
  
  fileprivate var apiKey = ""
  fileprivate var homeLocation: Location?
  
  fileprivate let locationManager: LocationManagerType
  fileprivate let networkClient: NetworkClientType
  
  init(locationManager: LocationManagerType = LocationManager(),
       networkClient: NetworkClientType = NetworkClient())
  {
    self.locationManager = locationManager
    self.networkClient = networkClient
    
    getAPIKey()
    homeLocation = locationManager.homeLocation.value
  }
}

// MARK: - Interface
extension WeatherManager {
  func getWeatherForecast() -> String
  {
    var message = ""
    
    fetchWeatherData()
      .then { data -> Void in
        let json = JSON(data: data)
        let currentTemp = String(json["currently"]["temperature"].intValue) + "°F"
        let low = String(json["daily"]["data"][0]["temperatureMin"].intValue) + "°F"
        let high = String(json["daily"]["data"][0]["temperatureMax"].intValue) + "°F"
        let dailySummary = json["daily"]["data"][0]["summary"].stringValue
        
        message = "It is currently \(currentTemp). The low today is \(low) and the high is \(high). "
                  + "Today's outlook: \(dailySummary)"
      }
      .catch { error in message = "An error occured!" }
    
    return message
  }
  
  func getWeatherIcon() -> String
  {
    guard let currentWeather = currentWeather.value
      else { return "clear-day" }
    
    switch(currentWeather["icon"].stringValue) {
    case "clear-night":         return "clear-night"
    case "rain":                return "rain"
    case "snow":                return "snow"
    case "sleet":               return "sleet"
    case "wind":                return "wind"
    case "fog":                 return "fog"
    case "cloudy":              return "cloudy"
    case "partly-cloudy-day":   return "partly-cloudy"
    case "partly-cloudy-night": return "partly-cloudy-night"
    case "thunderstorm":        return "storm"
    default:                    return "clear-day"
    }
  }
  
  func getWeatherForHome()
  {
    weatherFetched = false
    fetchWeatherData()
      .then { data -> Void in
        let json = JSON(data: data)
        
        self.currentWeather.value = json["currently"]
        self.dailyWeather.value = json["daily"]
        self.weatherFetched = true
      }
      .catch { error in NSLog("\(error)") }
  }
}

// MARK: - Helpers
fileprivate extension WeatherManager {
  func getAPIKey()
  {
    guard let file = Bundle.main.url(forResource: "config", withExtension: "json"),
          let data = try? Data(contentsOf: file)
      else { return log.error("Error parsing contents of config file!") }
    
    let json = JSON(data: data)
    apiKey = json["api_key"].stringValue
  }
  
  func fetchWeatherData() -> Promise<Data>
  {
    var homeString = ""
    if let home = homeLocation {
      homeString = "\(home.latitude),\(home.longitude)"
    }
    let encodedLocation = homeString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let options = "?exclude=[minutely,hourly,flags,alerts]".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "https://api.darksky.net/forecast/\(apiKey)/\(encodedLocation)\(options)"
    
    return networkClient.makeRequest(urlString: urlString)
  }
}
