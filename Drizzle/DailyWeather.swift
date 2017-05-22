//
//  DailyWeather.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/22/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import SwiftyJSON

class DailyWeather: JSONConvertable {
  var temperatureMin: Double
  var temperatureMax: Double
  var precipProbability: Double
  var precipType: String
  var humidity: Double
  var windSpeed: Double
  
  init(temperatureMin: Double,
       temperatureMax: Double,
       precipProbability: Double,
       precipType: String,
       humidity: Double,
       windSpeed: Double)
  {
    self.temperatureMin = temperatureMin
    self.temperatureMax = temperatureMax
    self.precipProbability = precipProbability
    self.precipType = precipType
    self.humidity = humidity
    self.windSpeed = windSpeed
  }
  
  convenience required init?(from json: JSON)
  {
    guard let temperatureMin = json[DailyWeather.TempMinKey].double,
          let temperatureMax = json[DailyWeather.TempMaxKey].double,
          let precipProbability = json[DailyWeather.PrecipProbabiltiyKey].double,
          let precipType = json[DailyWeather.PrecipTypeKey].string,
          let humidity = json[DailyWeather.HumidityKey].double,
          let windSpeed = json[DailyWeather.WindSpeedKey].double
      else { log.warning("Failed to parse DailyWeather from JSON"); return nil }
    
    self.init(temperatureMin: temperatureMin,
              temperatureMax: temperatureMax,
              precipProbability: precipProbability,
              precipType: precipType,
              humidity: humidity,
              windSpeed: windSpeed)
  }
}

// MARK: - JSONConvertable
extension DailyWeather {
  func toJSON() -> JSON
  {
    let json: JSON = [
      DailyWeather.TempMinKey: temperatureMin,
      DailyWeather.TempMaxKey: temperatureMax,
      DailyWeather.PrecipProbabiltiyKey: precipProbability,
      DailyWeather.PrecipTypeKey: precipType,
      DailyWeather.HumidityKey: humidity,
      DailyWeather.WindSpeedKey: windSpeed
    ]
    
    return json
  }
}

// MARK: - Equatable
extension DailyWeather: Equatable {}
func ==(lhs: DailyWeather, rhs: DailyWeather) -> Bool
{
  return lhs.temperatureMin == rhs.temperatureMin &&
         lhs.temperatureMax == rhs.temperatureMax &&
         lhs.precipProbability == rhs.precipProbability &&
         lhs.precipType == rhs.precipType &&
         lhs.humidity == rhs.humidity &&
         lhs.windSpeed == rhs.windSpeed
}

// MARK: - Helpers
fileprivate extension DailyWeather {
  static let TempMinKey = "temp_min"
  static let TempMaxKey = "temp_max"
  static let PrecipProbabiltiyKey = "precip_probability"
  static let PrecipTypeKey = "precip_type"
  static let HumidityKey = "humidity"
  static let WindSpeedKey = "wind_speed"
}
