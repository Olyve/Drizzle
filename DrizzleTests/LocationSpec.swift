//
//  LocationSpec.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import Nimble
import Quick
import SwiftyJSON

class LocationSpec: QuickSpec {
  override func spec() {
    let currentWeather = CurrentWeather.fromJSONFile()
    
    describe("Location") {
      it("should initialize") {
        let location = Location(latitude: "lat",
                                longitude: "lng",
                                formattedAddress: "address",
                                lastFetchTime: 1234,
                                currentWeather: currentWeather)
        
        expect(location).toNot(beNil())
        expect(location.latitude).to(equal("lat"))
        expect(location.longitude).to(equal("lng"))
        expect(location.formattedAddress).to(equal("address"))
        expect(location.lastFetchTime).to(equal(1234))
        expect(location.currentWeather).to(equal(currentWeather))
      }
      
      it("should initialize from JSON") {
        let subject = Location.fromJSONFile()
        
        expect(subject).toNot(beNil())
        expect(subject?.latitude).to(equal("74"))
        expect(subject?.longitude).to(equal("34"))
        expect(subject?.formattedAddress).to(equal("New York, NY"))
        expect(subject?.lastFetchTime).to(equal(12345678))
        expect(subject?.currentWeather).to(equal(currentWeather))
      }
      
      it("should be equatable") {
        let location1 = Location(latitude: "74",
                                 longitude: "34",
                                 formattedAddress: "New York, NY",
                                 lastFetchTime: 12345678,
                                 currentWeather: currentWeather)
        let location2 = Location.fromJSONFile()
        
        expect(location1).to(equal(location2))
      }
      
      describe("toJSON") {
        it("correctly converts to JSON") {
          let subject = Location.fromJSONFile()
          let json = subject!.toJSON()
          
          expect(json["latitude"].stringValue).to(equal("74"))
          expect(json["longitude"].stringValue).to(equal("34"))
          expect(json["address"].stringValue).to(equal("New York, NY"))
          expect(json["last_fetch"].intValue).to(equal(12345678))
          expect(json["current_weather"]).to(equal(currentWeather?.toJSON()))
        } 
      }
    }
  }
}
