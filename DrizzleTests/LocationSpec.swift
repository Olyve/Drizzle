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
    describe("Location") {
      let dictionary = [ "latitude" : "1", "longitude" : "2", "address" : "some address"]
      
      it("should initialize") {
        let location = Location(latitude: "lat", longitude: "lng", formattedAddress: "address")
        
        expect(location).toNot(beNil())
        expect(location.latitude).to(equal("lat"))
        expect(location.longitude).to(equal("lng"))
        expect(location.formattedAddress).to(equal("address"))
      }
      
      it("should initialize from JSON") {
        let json = JSON(dictionary)
        let subject = Location(from: json)
        
        expect(subject).toNot(beNil())
        expect(subject?.latitude).to(equal("1"))
        expect(subject?.longitude).to(equal("2"))
        expect(subject?.formattedAddress).to(equal("some address"))
      }
      
      it("should be equatable") {
        let location1 = Location(latitude: "1", longitude: "2", formattedAddress: "some address")
        let location2 = Location(from: JSON(dictionary))
        
        expect(location1).to(equal(location2))
      }
      
      describe("toJSON") {
        it("correctly converts to JSON") {
          let subject = Location(latitude: "245", longitude: "345", formattedAddress: "London")
          let json = subject.toJSON()
          
          expect(json["latitude"].stringValue).to(equal("245"))
          expect(json["longitude"].stringValue).to(equal("345"))
          expect(json["address"].stringValue).to(equal("London"))
        } 
      }
    }
  }
}
