//
//  HomeViewModelSpec.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import Nimble
import Quick

class HomeViewModelSpec: QuickSpec {
  override func spec() {
    describe("Home View Model") {
      var subject: HomeViewModel!
      let userDefaults = UserDefaults(suiteName: "HomeViewModelTests")!
      
      describe("init") {
        context("home location is set") {
          let location = Location(latitude: "1", longitude: "1", formattedAddress: "some address")
          
          beforeEach {
            let locationData = NSKeyedArchiver.archivedData(withRootObject: location)
            userDefaults.set(locationData, forKey: "home_location")
            
            subject = HomeViewModel(userDefaults: userDefaults)
          }
          
          it("should fetch and return the home location") {
            expect(subject.homeLocation).to(equal(location))
          }
        }
        
        context("home location is not set") {
          beforeEach {
            userDefaults.removeObject(forKey: "home_location")
            subject = HomeViewModel(userDefaults: userDefaults)
          }
          
          it("should return nil") {
            expect(subject.homeLocation).to(beNil())
          }
        }
      }
      
    }
  }
}
