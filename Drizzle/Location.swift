//
//  Location.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Foundation

class Location: NSObject {
  var latitude: String
  var longitude: String
  var formattedAddress: String
  
  init(latitude: String, longitude: String, formattedAddress: String)
  {
    self.latitude = latitude
    self.longitude = longitude
    self.formattedAddress = formattedAddress
  }
  
  // FIXME: I don't like force unwrapping these even though I know they are strings. Need to fix this.
  required convenience init?(coder aDecoder: NSCoder)
  {
    let latitude = aDecoder.decodeObject(forKey: Location.LatitudeKey) as! String
    let longitude = aDecoder.decodeObject(forKey: Location.LongitudeKey) as! String
    let formattedAddress = aDecoder.decodeObject(forKey: Location.AddressKey) as! String
    
    self.init(latitude: latitude, longitude: longitude, formattedAddress: formattedAddress)
  }
}

// MARK: - NSCoder
extension Location: NSCoding {
  func encode(with aCoder: NSCoder)
  {
    aCoder.encode(latitude, forKey: Location.LatitudeKey)
    aCoder.encode(longitude, forKey: Location.LongitudeKey)
    aCoder.encode(formattedAddress, forKey: Location.AddressKey)
  }
}

// MARK: - Equatable
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
