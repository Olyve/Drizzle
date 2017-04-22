//
//  HomeViewController.swift
//  Drizzle
//
//  Created by Sam Galizia on 4/11/17.
//  Copyright © 2017 Sam Galizia. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

class HomeViewController: UIViewController {
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  
  fileprivate let viewModel: HomeViewModelType
  
  fileprivate let disposeBag = DisposeBag()
  
  init(viewModel: HomeViewModelType = HomeViewModel())
  {
    self.viewModel = viewModel
    
    super.init(nibName: "HomeViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Lifecycle
extension HomeViewController {
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    setBindings()
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    
    fetchWeather()
  }
}

// MARK: - Helpers
fileprivate extension HomeViewController {
  func setBindings()
  {
    viewModel.homeLocation.asObservable()
      .subscribe(onNext: { self.showChooseLocationIfNoHome(location: $0) })
      .addDisposableTo(disposeBag)
    
    viewModel.homeLocation.asObservable()
      .subscribe(onNext: { location in
        if let location = location {
          self.addressLabel.text = location.formattedAddress
        }
      })
      .addDisposableTo(disposeBag)
    
    setWeatherBindings()
  }
  
  func setWeatherBindings()
  {
    viewModel.currentWeather.asObservable()
      .subscribe(onNext: { json in
        if let json = json {
          self.summaryLabel.text = json["summary"].stringValue
          self.temperatureLabel.text = String(json["temperature"].intValue) + "°F"
          
          let icon = self.viewModel.getWeatherIcon()
          self.weatherIcon.image = UIImage(named: icon) ?? UIImage(named: "clear-day")
        }
        else {
          NSLog("Error: Unable to get current weather from JSON: \(json)")
        }
      })
      .addDisposableTo(disposeBag)
  }
  
  func showChooseLocationIfNoHome(location: Location?)
  {
    if location == nil {
      let chooseLocationViewController = ChooseLocationViewController()
      navigationController?.pushViewController(chooseLocationViewController, animated: true)
    }
  }
  
  func fetchWeather()
  {
    viewModel.getWeatherForHome()
  }
}
