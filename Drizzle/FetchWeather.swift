//
//  FetchWeather.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/21/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import PromiseKit
import SwiftyJSON

protocol FetchWeatherType {
  func fetchWeather(for location: Location) -> Promise<JSON>
}

class FetchWeather: FetchWeatherType {
  fileprivate var apiKey: String = ""
  
  fileprivate let networkClient: NetworkClientType
  
  init(networkClient: NetworkClientType = NetworkClient())
  {
    self.networkClient = networkClient
    
    apiKey = isRunningUnitTests() ? "api_key" : getAPIKey()
  }
}

// MARK: - Interface
extension FetchWeather {
  func fetchWeather(for location: Location) -> Promise<JSON>
  {
    let locationString = "\(location.latitude),\(location.longitude)"
    let encodedLocation = locationString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "encoding error"
    let options = "?exclude=[minutely,hourly,flags,alerts]"
    let urlString = "https://api.darksky.net/forecast/\(apiKey)/\(encodedLocation)\(options)"
    
    return networkClient.makeRequest(urlString: urlString).then { data in JSON(data: data) }
  }
}

// MARK: - Helpers
fileprivate extension FetchWeather {
  func getAPIKey() -> String
  {
    guard let file = Bundle.main.url(forResource: "config", withExtension: "json"),
          let data = try? Data(contentsOf: file)
      else { log.error("Error parsing contents of config file!"); return "" }
    
    let json = JSON(data: data)
    return json["api_key"].stringValue
  }
}
