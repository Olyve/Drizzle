//
//  CurrentWeather.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/9/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import SwiftyJSON

class CurrentWeather: JSONConvertable {
  var summary: String
  var icon: String
  var temperature: Double
  var apparentTemperature: Double
  
  init(summary: String, icon: String, temperature: Double, apparentTemperature: Double)
  {
    self.summary = summary
    self.icon = icon
    self.temperature = temperature
    self.apparentTemperature = apparentTemperature
  }
  
  convenience required init?(from json: JSON)
  {
    guard let summary = json[CurrentWeather.SummaryKey].string,
          let icon = json[CurrentWeather.IconKey].string,
          let temperature = json[CurrentWeather.TemperatureKey].double,
          let apparentTemperature = json[CurrentWeather.ApparentTempKey].double
      else { log.warning("Failed to parse CurrentWeather from JSON"); return nil }
    
    self.init(summary: summary, icon: icon, temperature: temperature, apparentTemperature: apparentTemperature)
  }
}

// MARK: - JSONConvertable
extension CurrentWeather {
  func toJSON() -> JSON {
    let dictionary: [AnyHashable: Any] = [
      CurrentWeather.SummaryKey: summary,
      CurrentWeather.IconKey: icon,
      CurrentWeather.TemperatureKey: temperature,
      CurrentWeather.ApparentTempKey: apparentTemperature
    ]
    
    return JSON(dictionary)
  }
}

// MARK: - Equatable
extension CurrentWeather: Equatable {}
func ==(lhs: CurrentWeather, rhs: CurrentWeather) -> Bool
{
  return lhs.summary == rhs.summary &&
         lhs.icon == rhs.icon &&
         lhs.temperature == rhs.temperature &&
         lhs.apparentTemperature == rhs.apparentTemperature
}

// MARK: - Helpers
fileprivate extension CurrentWeather {
  static let SummaryKey = "summary"
  static let IconKey = "icon"
  static let TemperatureKey = "temperature"
  static let ApparentTempKey = "apparent_temp"
}
