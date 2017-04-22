//
//  LocationManagerSpec.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/17/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import Nimble
import Quick

class LocationManagerSpec: QuickSpec {
  override func spec() {
    describe("LocationManager") {
      var subject: LocationManager!
      var userDefaults: UserDefaults!
      
      beforeSuite {
        userDefaults = UserDefaults(suiteName: "LocationManagerTests")!
        
        subject = LocationManager(userDefaults: userDefaults)
      }
      
      describe("init") {
        beforeEach {
          userDefaults.removeObject(forKey: "home_location")
        }
        
        context("with no stored homeLocation") {
          it("should set homeLocation to nil") {
            expect(subject.homeLocation.value).to(beNil())
          }
        }
        
        context("with stored homeLocation") {
          it("should set homeLocation to stored value") {
            let location = Location(latitude: "32", longitude: "44", formattedAddress: "address")
            userDefaults.set(location.toJSON(), forKey: "home_location")
            
            expect(subject.homeLocation.value).to(equal(location))
          }
        }
        
        context("homeLocation changes") {
          it("should update homeLocation automatically") {
            let location = Location(latitude: "32", longitude: "44", formattedAddress: "address")
            userDefaults.set(location.toJSON(), forKey: "home_location")
            
            expect(subject.homeLocation.value).to(equal(location))
            
            let location2 = Location(latitude: "75.999", longitude: "-43.56", formattedAddress: "something here")
            userDefaults.set(location2.toJSON(), forKey: "home_location")
            
            expect(subject.homeLocation.value).to(equal(location2))
          }
        }
      }
      
    }
  }
}

