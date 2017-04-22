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
      
      it("correctly initializes from JSON") {
        let json = JSON(dictionary)
        let subject = Location(from: json)
        
        expect(subject).toNot(beNil())
        expect(subject?.latitude).to(equal("1"))
        expect(subject?.longitude).to(equal("2"))
        expect(subject?.formattedAddress).to(equal("some address"))
      }
      
      it("correctly converts to JSON") {
        let subject = Location(latitude: "245", longitude: "345", formattedAddress: "London")
        let json = subject.toJSON()
        
        expect(json["latitude"] as? String).to(equal("245"))
        expect(json["longitude"] as? String).to(equal("345"))
        expect(json["address"] as? String).to(equal("London"))
      }
    }
  }
}
