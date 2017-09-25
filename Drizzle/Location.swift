//
//  Location.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import SwiftyJSON

class Location: JSONConvertable {
  var latitude: Double
  var longitude: Double
  var formattedAddress: String
  var lastFetchTime: Int
  var currentWeather: CurrentWeather?
  var dailyWeather: [DailyWeather]?
  
  init(latitude: Double,
       longitude: Double,
       formattedAddress: String,
       lastFetchTime: Int = 0,
       currentWeather: CurrentWeather? = nil,
       dailyWeather: [DailyWeather]? = nil)
  {
    self.latitude = latitude
    self.longitude = longitude
    self.formattedAddress = formattedAddress
    self.lastFetchTime = lastFetchTime
    self.currentWeather = currentWeather
    self.dailyWeather = dailyWeather
  }
  
  convenience required init?(from json: JSON)
  {
    guard let latitude = json[Location.LatitudeKey].double,
          let longitude = json[Location.LongitudeKey].double,
          let address = json[Location.AddressKey].string,
          let lastFetchTime = json[Location.LastFetchKey].int
      else { log.warning("Failed to parse Location from JSON data"); return nil }
    
    // Because these can be nil, they need to be left out of the guard statement or it will
    // return a nil Location when we really have a location with no weather data.
    let currentWeather = CurrentWeather(from: json[Location.CurrentWeatherKey])
    var dailyWeather: [DailyWeather]? = nil
    
    if let dailyJSON = json[Location.DailyWeatherKey].array {
      dailyWeather = dailyJSON.flatMap(DailyWeather.init(from:))
    }
    
    self.init(latitude: latitude,
              longitude: longitude,
              formattedAddress: address,
              lastFetchTime: lastFetchTime,
              currentWeather: currentWeather,
              dailyWeather: dailyWeather)
  }
}

// MARK: - JSONConvertable
extension Location {
  func toJSON() -> JSON
  {
    var json: JSON = [
      Location.LatitudeKey: latitude,
      Location.LongitudeKey: longitude,
      Location.AddressKey: formattedAddress,
      Location.LastFetchKey: lastFetchTime
    ]
    let currentJSON: JSON? = currentWeather?.toJSON()
    let dailyJSON: [JSON] = dailyWeather?.flatMap { $0.toJSON() } ?? [.null]
    
    json[Location.CurrentWeatherKey] = currentJSON ?? .null
    json[Location.DailyWeatherKey] = JSON(dailyJSON)
    
    return json
  }
}

// MARK: - Equatable
extension Location: Equatable {}
func ==(lhs: Location, rhs: Location) -> Bool
{
  return lhs.latitude == rhs.latitude &&
         lhs.longitude == rhs.longitude &&
         lhs.formattedAddress == rhs.formattedAddress &&
         lhs.lastFetchTime == rhs.lastFetchTime
  
        // Removed from the check as comparing optionals does not work without force unwrapping
        // them which is not safe nor is it smart in this situation.
        // lhs.currentWeather == rhs.currentWeather &&
        // lhs.dailyWeather == rhs.dailyWeather
}

// MARK: - Helpers
fileprivate extension Location {
  static let LatitudeKey = "latitude"
  static let LongitudeKey = "longitude"
  static let AddressKey = "address"
  static let LastFetchKey = "last_fetch"
  static let CurrentWeatherKey = "current_weather"
  static let DailyWeatherKey = "daily_weather"
}
