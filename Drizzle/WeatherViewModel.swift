//
//  WeatherViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/9/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import PromiseKit
import RxSwift
import RxCocoa
import SwiftyJSON

protocol WeatherViewModelType {
  func getWeatherForecast() -> String
}

class WeatherViewModel: WeatherViewModelType {
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
extension WeatherViewModel {
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
}

// MARK: - Helpers
fileprivate extension WeatherViewModel {
  func getAPIKey()
  {
    guard let file = Bundle.main.url(forResource: "config", withExtension: "json"),
      let data = try? Data(contentsOf: file)
      else { NSLog("Error parsing Data from config file"); return }
    
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
