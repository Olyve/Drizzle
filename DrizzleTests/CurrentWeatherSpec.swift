//
//  CurrentWeatherSpec.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/15/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import Nimble
import Quick
import SwiftyJSON

class CurrentWeatherSpec: QuickSpec {
  override func spec() {
    describe("CurrentWeather") {
      let weatherDictionary = [
        "summary": "sunny",
        "icon": "clear-night",
        "temperature": "45",
        "apparent_temp": "40"
      ]
      
      it("should initialize correctly") {
        let weather = CurrentWeather(summary: "sunny",
                                     icon: "clear-day",
                                     temperature: "45",
                                     apparentTemperature: "40")
        
        expect(weather).toNot(beNil())
        expect(weather.summary).to(equal("sunny"))
        expect(weather.icon).to(equal("clear-day"))
        expect(weather.temperature).to(equal("45"))
        expect(weather.apparentTemperature).to(equal("40"))
      }
      
      it("should initialize from JSON") {
        let weather = CurrentWeather(from: JSON(weatherDictionary))
        
        expect(weather).toNot(beNil())
        expect(weather?.summary).to(equal("sunny"))
        expect(weather?.icon).to(equal("clear-night"))
        expect(weather?.temperature).to(equal("45"))
        expect(weather?.apparentTemperature).to(equal("40"))
      }
      
      it("should be equatable")
      {
        let currentWeather1 = CurrentWeather.fromJSONFile()
        let currentWeather2 = CurrentWeather(summary: "clear",
                                             icon: "clear-day",
                                             temperature: "80",
                                             apparentTemperature: "85")
        expect(currentWeather1).to(equal(currentWeather2))
      }
      
      describe("toJSON") {
        it("should convert it to JSON") {
          let weather = CurrentWeather(summary: "Partly Cloudy",
                                       icon: "partly-cloudy",
                                       temperature: "56",
                                       apparentTemperature: "50")
          let json = weather.toJSON()
          
          expect(json["summary"].stringValue).to(equal("Partly Cloudy"))
          expect(json["icon"].stringValue).to(equal("partly-cloudy"))
          expect(json["temperature"].stringValue).to(equal("56"))
          expect(json["apparent_temp"].stringValue).to(equal("50"))
        }
      }
    }
  }
}
