//
//  ChooseLocationViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/13/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import PromiseKit
import SwiftyJSON

protocol ChooseLocationViewModelType {
  var homeLocation: Observable<Location?> { get }
  var apiLocation: Observable<Location?> { get }
  var isLoading: Observable<Bool> { get }
  
  func getLocationFrom(addressString: String)
  func setNewHomeLocation()
}

class ChooseLocationViewModel: ChooseLocationViewModelType {
  let homeLocation = Observable<Location?>(nil)
  let apiLocation = Observable<Location?>(nil)
  let isLoading = Observable<Bool>(false)
  
  fileprivate let locationManager: LocationManagerType
  fileprivate let networkClient: NetworkClientType
  
  init(locationManager: LocationManagerType = LocationManager(),
       networkClient: NetworkClientType = NetworkClient())
  {
    self.locationManager = locationManager
    self.networkClient = networkClient
    
    self.locationManager.homeLocation.bind(to: self.homeLocation)
  }
}

// MARK: - Interface
extension ChooseLocationViewModel {
  func getLocationFrom(addressString: String)
  {
    isLoading.next(true)
    let urlEncodedAddress = addressString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(urlEncodedAddress)"
    
    networkClient.makeRequest(urlString: urlString)
      .then { data -> Void in self.updateAPILocation(data: data) }
      .catch { error in NSLog("\(error)") }
  }
  
  func setNewHomeLocation()
  {
    if let home = apiLocation.value {
      locationManager.setHomeLocation(location: home)
    }
  }
}

// MARK: - Helpers
fileprivate extension ChooseLocationViewModel {
  func updateAPILocation(data: Data)
  {
    let json = JSON(data: data)
    
    guard let lat = json["results"][0]["geometry"]["location"]["lat"].double,
          let lng = json["results"][0]["geometry"]["location"]["lng"].double,
          let address = json["results"][0]["formatted_address"].string
      else { NSLog("Error: Unable to parse location data from results JSON"); return }
    
    apiLocation.value = Location(latitude: lat, longitude: lng, formattedAddress: address)
    isLoading.next(false)
  }
}
