//
//  APIService.swift
//  Drizzle
//
//  Created by Sam Galizia on 9/25/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Moya
import SwiftyJSON

enum APIService {
  // Google Maps API
  case verifyLocation(address: String)
  
  // DarkSky API
  case fetchWeather(location: LocationMO)
}

// MARK: TargetType Protocol Implementation
extension APIService: TargetType {
  var baseURL: URL {
    switch self {
    case .verifyLocation:
      return URL(string: "https://maps.googleapis.com")!
    case .fetchWeather:
      let apiKey = getAPIKey()
      return URL(string: "https://api.darksky.net/forecast/\(apiKey)")!
    }
  }
  
  var path: String {
    switch self {
    case .verifyLocation:
      return "/maps/api/geocode/json"
    case .fetchWeather(location: let location):
      return "/\(location.latitude),\(location.longitude)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .verifyLocation, .fetchWeather:
      return .get
    }
  }
  
  var sampleData: Data {
    switch self {
    default:
      return "Not implemented".data(using: .utf8)!
    }
  }
  
  var task: Task {
    switch self {
    case .verifyLocation(address: let address):
      let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
      return .requestParameters(parameters: ["address" : encodedAddress], encoding: URLEncoding.queryString)
    case .fetchWeather(let location):
      let exclude = "minutely,flags,alerts"
      let units = location.useMetric ? "si" : "us"
      return .requestParameters(parameters: ["exclude": "\(exclude)", "units": units], encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      return nil
    }
  }
}

// MARK: - Helpers
private extension APIService {
  func getAPIKey() -> String
  {
    guard let file = Bundle.main.url(forResource: "config", withExtension: "json"),
      let data = try? Data(contentsOf: file)
      else { log.error("Error parsing contents of config file!"); return "" }
    
    let json = JSON(data: data)
    return json["api_key"].stringValue
  }
}
