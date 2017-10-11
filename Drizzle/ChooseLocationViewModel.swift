//
//  ChooseLocationViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/13/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import Bond
import CoreData
import Moya
import PromiseKit
import SwiftyJSON

protocol ChooseLocationViewModelType {
  var homeLocation: Observable<LocationMO?> { get }
  var apiLocation: Observable<Location?> { get }
  var isLoading: Observable<Bool> { get }
  
  func getLocationFrom(addressString: String)
  func setNewHomeLocation()
}

class ChooseLocationViewModel: ChooseLocationViewModelType {
  let homeLocation = Observable<LocationMO?>(nil)
  let apiLocation = Observable<Location?>(nil)
  let isLoading = Observable<Bool>(false)
  
  private let locationManager: LocationManagerType
  private let apiService = MoyaProvider<APIService>()
  private let managedContext: NSManagedObjectContext!
  
  init(managedContext: NSManagedObjectContext)
  {
    self.managedContext = managedContext
    self.locationManager = LocationManager(managedContext: self.managedContext)
    
    self.locationManager.homeLocation.bind(to: self.homeLocation)
  }
}

// MARK: - Interface
extension ChooseLocationViewModel {
  func getLocationFrom(addressString: String)
  {
    isLoading.next(true)
    
    apiService.request(.verifyLocation(address: addressString)) { result in
      switch result {
      case .success(let moyaResponse):
        do {
          try moyaResponse.filterSuccessfulStatusCodes()
          if let data = JSON(rawValue: try moyaResponse.mapJSON()) {
            self.updateAPILocation(json: data)
          }
          else {
            log.error("Failed to convert response data to JSON")
          }
        }
        catch let error {
          log.error(error.localizedDescription)
        }
      case .failure(let error):
        log.error(error.localizedDescription)
      }
    }
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
  func updateAPILocation(json: JSON)
  {
    guard let lat = json["results"][0]["geometry"]["location"]["lat"].double,
          let lng = json["results"][0]["geometry"]["location"]["lng"].double,
          let address = json["results"][0]["formatted_address"].string
      else { NSLog("Error: Unable to parse location data from results JSON"); return }
    
    apiLocation.value = Location(latitude: lat, longitude: lng, formattedAddress: address)
    isLoading.next(false)
  }
}
