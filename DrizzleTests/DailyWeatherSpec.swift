//
//  DailyWeatherSpec.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/22/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import Nimble
import Quick

class DailyWeatherSpec: QuickSpec {
  override func spec() {
    describe("DailyWeather") {
      
      it("should initialize correctly") {
        let dailyWeather = DailyWeather(time: 12345,
                                        summary: "Rain tonight",
                                        icon: "rain",
                                        temperatureMin: 34,
                                        temperatureMax: 56,
                                        precipProbability: 0.56,
                                        precipType: "rain",
                                        humidity: 0.34,
                                        windSpeed: 4.5)
        
        expect(dailyWeather).toNot(beNil())
        expect(dailyWeather.time).to(equal(12345))
        expect(dailyWeather.summary).to(equal("Rain tonight"))
        expect(dailyWeather.icon).to(equal("rain"))
        expect(dailyWeather.temperatureMin).to(equal(34))
        expect(dailyWeather.temperatureMax).to(equal(56))
        expect(dailyWeather.precipProbability).to(equal(0.56))
        expect(dailyWeather.precipType).to(equal("rain"))
        expect(dailyWeather.humidity).to(equal(0.34))
        expect(dailyWeather.windSpeed).to(equal(4.5))
      }
      
      it("should initialize from JSON") {
        let dailyWeather = DailyWeather.fromJSONFile()!
        
        expect(dailyWeather).toNot(beNil())
        expect(dailyWeather.time).to(equal(123456789))
        expect(dailyWeather.summary).to(equal("Rain starting in the evening."))
        expect(dailyWeather.icon).to(equal("rain"))
        expect(dailyWeather.temperatureMin).to(equal(34))
        expect(dailyWeather.temperatureMax).to(equal(56))
        expect(dailyWeather.precipProbability).to(equal(0.56))
        expect(dailyWeather.precipType).to(equal("rain"))
        expect(dailyWeather.humidity).to(equal(0.34))
        expect(dailyWeather.windSpeed).to(equal(4.5))
      }
      
      it("should be equatable") {
        let daily1 = DailyWeather.fromJSONFile()!
        let daily2 = DailyWeather(time: 123456789,
                                  summary: "Rain starting in the evening.",
                                  icon: "rain",
                                  temperatureMin: 34,
                                  temperatureMax: 56,
                                  precipProbability: 0.56,
                                  precipType: "rain",
                                  humidity: 0.34,
                                  windSpeed: 4.5)
        expect(daily1).to(equal(daily2))
      }
      
      describe("toJSON") {
        it("should convert it to JSON") {
          let subject = DailyWeather.fromJSONFile()!
          
          let json = subject.toJSON()
          
          expect(json["time"].intValue).to(equal(123456789))
          expect(json["summary"].stringValue).to(equal("Rain starting in the evening."))
          expect(json["icon"].stringValue).to(equal("rain"))
          expect(json["temp_min"].intValue).to(equal(34))
          expect(json["temp_max"].intValue).to(equal(56))
          expect(json["precip_probability"].doubleValue).to(equal(0.56))
          expect(json["precip_type"].stringValue).to(equal("rain"))
          expect(json["humidity"].doubleValue).to(equal(0.34))
          expect(json["wind_speed"].doubleValue).to(equal(4.5))
        }
      }
    }
  }
}
