//
//  HomeViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import PromiseKit
import RxSwift
import RxCocoa
import SwiftyJSON
import UIKit

protocol HomeViewModelType {
  var homeLocation: Variable<Location?> { get }
  var weatherFetched: Bool { get }
  var currentWeather: Variable<JSON?> { get }
  
  func getWeatherForHome()
  func getWeatherIcon() -> String
}

class HomeViewModel: HomeViewModelType {
  enum Errors: Error {
    case weatherFetched
  }
  
  let homeLocation = Variable<Location?>(nil)
  var weatherFetched = false
  var currentWeather = Variable<JSON?>(nil)
  
  fileprivate let disposeBag = DisposeBag()
  fileprivate var apiKey = ""
  
  fileprivate let locationManager: LocationManagerType
  fileprivate let networkClient: NetworkClientType
  
  init(locationManager: LocationManagerType = LocationManager(),
       networkClient: NetworkClientType = NetworkClient())
  {
    self.locationManager = locationManager
    self.networkClient = networkClient
    
    getAPIKey()
    locationManager.homeLocation.asObservable().bindTo(self.homeLocation).addDisposableTo(disposeBag)
  }
}

// MARK: - Interface
extension HomeViewModel {
  func getWeatherForHome()
  {
    fetchWeatherData()
      .then { data -> Void in
        let json = JSON(data: data)
        
        self.currentWeather.value = json["currently"]
        self.weatherFetched = true
      }
      .catch { error in NSLog("\(error)") }
  }
  
  func getWeatherIcon() -> String
  {
    guard let currentWeather = currentWeather.value
      else { return "clear-day" }
    
    switch(currentWeather["icon"].stringValue) {
      case "rain":          return "rain"
      case "snow":          return "snow"
      case "wind":          return "wind"
      case "cloudy":        return "cloudy"
      case "partly-cloudy": return "partly-cloudy"
      default:              return "clear-day"
    }
  }
}

// MARK: - Helpers
private extension HomeViewModel {
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
    guard weatherFetched == false,
      let home = homeLocation.value
      else { return Promise(error: Errors.weatherFetched) }
    
    let homeString = "\(home.latitude),\(home.longitude)"
    let encodedLocation = homeString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let options = "?exlude=[minutely,hourly,flags,alerts]".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "https://api.darksky.net/forecast/\(apiKey)/\(encodedLocation)\(options)"
    
    return networkClient.makeRequest(urlString: urlString)
  }
}
