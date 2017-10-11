//
//  MockNetworkClient.swift
//  Drizzle
//
//  Created by Sam Galizia on 5/22/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

@testable import Drizzle
import PromiseKit

class MockNetworkClient: NetworkClientType {
  var url: String = ""
  var makeRequestWasCalled = false
  
  func makeRequest(urlString: String) -> Promise<Data>
  {
    makeRequestWasCalled = true
    url = urlString
    
    return Promise<Data>(value: Data())
  }
}
