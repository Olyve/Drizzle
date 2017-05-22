//
//  FetchWeatherSpec.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/22/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import Nimble
import Quick

class FetchWeatherSpec: QuickSpec {
  override func spec() {
    describe("FetchWeather") {
      let networkClient = MockNetworkClient()
      let location = Location.fromJSONFile()!
      let url = "https://api.darksky.net/forecast/api_key/74.0,34.0?exclude=[minutely,hourly,flags,alerts]"
      
      let subject = FetchWeather(networkClient: networkClient)
      
      it("should make correct request") {
        let _ = subject.fetchWeather(for: location)
            
        expect(networkClient.makeRequestWasCalled).toEventually(beTrue())
        expect(networkClient.url).toEventually(equal(url))
      }
    }
  }
}
