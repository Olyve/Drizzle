//
//  ChooseLocationViewModel.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/13/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import PromiseKit
import RxCocoa
import RxSwift
import SwiftyJSON

protocol ChooseLocationViewModelType {
  var homeLocation: Variable<Location?> { get }
  var apiLocation: Variable<Location?> { get }
  var isLoading: BehaviorSubject<Bool> { get }
  
  func getLocationFrom(addressString: String)
  func setNewHomeLocation()
}

class ChooseLocationViewModel: ChooseLocationViewModelType {
  let homeLocation = Variable<Location?>(nil)
  let apiLocation = Variable<Location?>(nil)
  let isLoading = BehaviorSubject<Bool>(value: false)
  
  fileprivate let disposeBag = DisposeBag()
  
  fileprivate let locationManager: LocationManagerType
  fileprivate let networkClient: NetworkClientType
  
  init(locationManager: LocationManagerType = LocationManager(),
       networkClient: NetworkClientType = NetworkClient())
  {
    self.locationManager = locationManager
    self.networkClient = networkClient
    
    self.locationManager.homeLocation.asObservable()
      .bindTo(homeLocation)
      .addDisposableTo(disposeBag)
  }
}

// MARK: - Interface
extension ChooseLocationViewModel {
  func getLocationFrom(addressString: String)
  {
    isLoading.onNext(true)
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
    
    guard let lat = json["results"][0]["geometry"]["location"]["lat"].float,
          let lng = json["results"][0]["geometry"]["location"]["lng"].float,
          let address = json["results"][0]["formatted_address"].string
      else { NSLog("Error: Unable to parse location data from results JSON"); return }
    
    apiLocation.value = Location(latitude: String(lat), longitude: String(lng), formattedAddress: address)
    isLoading.onNext(false)
  }
}
