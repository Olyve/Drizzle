//
//  CurrentWeather.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/9/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import SwiftyJSON

class CurrentWeather {
  var summary: String
  var icon: String
  var temperature: String
  var apparentTemperature: String
  
  init(summary: String, icon: String, temperature: String, apparentTemperature: String)
  {
    self.summary = summary
    self.icon = icon
    self.temperature = temperature
    self.apparentTemperature = apparentTemperature
  }
  
  convenience init?(from json: JSON)
  {
    guard let summary = json[CurrentWeather.SummaryKey].string,
          let icon = json[CurrentWeather.IconKey].string,
          let temperature = json[CurrentWeather.TemperatureKey].string,
          let apparentTemperature = json[CurrentWeather.ApparentTempKey].string
      else { return nil }
    
    self.init(summary: summary, icon: icon, temperature: temperature, apparentTemperature: apparentTemperature)
  }
}

// MARK: - JSONable
extension CurrentWeather {
  func toJSON() -> [AnyHashable: Any] {
    let dictionary: [AnyHashable: Any] = [
      CurrentWeather.SummaryKey: summary,
      CurrentWeather.IconKey: icon,
      CurrentWeather.TemperatureKey: temperature,
      CurrentWeather.ApparentTempKey: apparentTemperature
    ]
    
    return dictionary
  }
}

// MARK: - Helpers
fileprivate extension CurrentWeather {
  static let SummaryKey = "summary"
  static let IconKey = "icon"
  static let TemperatureKey = "temperature"
  static let ApparentTempKey = "apparent_temp"
}
