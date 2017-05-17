//
//  Location.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import SwiftyJSON

class Location: JSONConvertable {
  var latitude: String
  var longitude: String
  var formattedAddress: String
  
  init(latitude: String, longitude: String, formattedAddress: String)
  {
    self.latitude = latitude
    self.longitude = longitude
    self.formattedAddress = formattedAddress
  }
  
  convenience required init?(from json: JSON)
  {
    guard let latitude = json[Location.LatitudeKey].string,
          let longitude = json[Location.LongitudeKey].string,
          let address = json[Location.AddressKey].string
      else { log.warning("Failed to parse Location from JSON data"); return nil }
    
    self.init(latitude: latitude, longitude: longitude, formattedAddress: address)
  }
}

// MARK: - JSONable
extension Location {
  func toJSON() -> JSON
  {
    let json: JSON = [
      Location.LatitudeKey: latitude,
      Location.LongitudeKey: longitude,
      Location.AddressKey: formattedAddress
    ]
    
    return json
  }
}

// MARK: - Equatable
extension Location: Equatable {}
func ==(lhs: Location, rhs: Location) -> Bool
{
  return lhs.latitude == rhs.latitude &&
         lhs.longitude == rhs.longitude &&
         lhs.formattedAddress == rhs.formattedAddress
}

// MARK: - Helpers
fileprivate extension Location {
  static let LatitudeKey = "latitude"
  static let LongitudeKey = "longitude"
  static let AddressKey = "address"
}
