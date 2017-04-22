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
import RxTest

class HomeViewModelSpec: QuickSpec {
  override func spec() {
    describe("Home View Model") {
      var subject: HomeViewModel!
      var locationManager: LocationManagerType!
      
      beforeSuite {
        locationManager = MockLocationManager()
        subject = HomeViewModel(locationManager: locationManager)
      }
      
      describe("init") {
        it("should bind locationManager.homeLocation to self.homeLocation") {
          let location = Location(latitude: "56", longitude: "34", formattedAddress: "address here")
          locationManager.homeLocation.value = location
          
          expect(subject.homeLocation.value).to(equal(location))
          
          locationManager.homeLocation.value = nil
          
          expect(subject.homeLocation.value).to(beNil())
        }
      }
      
    }
  }
}
