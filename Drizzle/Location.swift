//
//  Location.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

// TODO: Find out if this is even necessary. The CoreData model may be all that is required.

import SwiftyJSON

final class Location {
  var latitude: Double
  var longitude: Double
  var formattedAddress: String
  var lastFetchTime: Int32
  var isHome: Bool
  
  init(latitude: Double, longitude: Double, formattedAddress: String, lastFetchTime: Int32 = 0, isHome: Bool = false)
  {
    self.latitude = latitude
    self.longitude = longitude
    self.formattedAddress = formattedAddress
    self.lastFetchTime = lastFetchTime
    self.isHome = isHome
  }
}

// MARK: - Equatable
extension Location: Equatable {}
func ==(lhs: Location, rhs: Location) -> Bool
{
  return lhs.latitude == rhs.latitude &&
         lhs.longitude == rhs.longitude &&
         lhs.formattedAddress == rhs.formattedAddress &&
         lhs.lastFetchTime == rhs.lastFetchTime
}

